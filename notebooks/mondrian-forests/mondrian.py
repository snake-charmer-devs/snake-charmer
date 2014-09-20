import random

import numpy as np

from numba import jit


# Candidates for memoization?

@jit
def get_colwise_min_max(data):
    return (data.min(axis=0), data.max(axis=0))

@jit
def get_data_range(min_d, max_d):
    range_d = max_d - min_d
    return (range_d, range_d.sum())

@jit
def sample_multinomial_scores(scores):
    scores_cumsum = np.cumsum(scores)
    s = scores_cumsum[-1] * np.random.rand(1)
    k = int(np.sum(s > scores_cumsum))
    return k

@jit
def sample_multinomial(prob):
    try:
        k = int(np.where(np.random.multinomial(1, prob, size=1)[0]==1)[0])
    except TypeError:
        print('problem in sample_multinomial: prob = ', prob)
        raise TypeError


@jit
class MondrianNode(object):

    
    def __init__(self, n_dims, n_labels, parent, budget):
        self.min_d = np.zeros(n_dims)
        self.max_d = np.zeros(n_dims)
        self.range_d = np.zeros(n_dims)
        self.sum_range_d = np.zeros(n_dims)
        self.label_counts = np.zeros(n_labels)
        self.budget = budget
        self.max_split_cost = 0
        self.parent = parent
        self.left = None
        self.right = None
        self.split_dim = None
        self.split_point = None
        
    
    @jit
    def update(self, data, labels):
        # Update bounding box and label counts
        self.min_d, self.max_d = get_colwise_min_max(data)
        self.range_d, self.sum_range_d = get_data_range(self.min_d, self.max_d)
        self.label_counts += np.bincount(labels, minlength=len(self.label_counts))
        

    @jit
    def apply_split(self, data):
        # Apply this node's existing splitting criterion to some data
        # and return a boolean index (True==goes left, False==goes right)
        return data[:, self.split_dim] <= self.split_point
    
    
    @jit
    def is_leaf(self):
        if self.left is None:
            assert self.right is None
            return True
        else:
            assert self.right is not None
            return False

        
    @jit
    def is_pure(self):
        return np.count_nonzero(self.label_counts) < 2


@jit
class MondrianTree(object):
    
    
    def __init__(self, n_dims, n_labels, budget):
        self.n_dims = n_dims
        self.n_labels = n_labels
        self.root = MondrianNode(n_dims, n_labels, None, budget)
        
    
    @jit
    def extend(self, data, labels):
        self._extend_node(self.root, data, labels)
    
    
    @jit
    def _extend_node(self, node, data, labels):
        
        min_d, max_d = get_colwise_min_max(data)
        additional_extent_lower = np.maximum(0, node.min_d - min_d)
        additional_extent_upper = np.maximum(0, max_d - node.max_d)
        expo_parameter = additional_extent_lower.sum() + additional_extent_upper.sum()
        
        is_leaf = node.is_leaf()
        if expo_parameter == 0 or is_leaf:
            # Don't split if (a) none of the new data is outside the existing bounding box,
            # or (b) it's a leaf node (we don't split these, we grow them)
            split_cost = np.inf
        else:
            # The bigger the new bounding box relative to the old one, the more likely we are to split the node
            split_cost = random.expovariate(expo_parameter)
        
        if split_cost < node.max_split_cost and not is_leaf:
            # Stop what we're doing and instigate a node split instead
            self._split_node(node, data, labels, split_cost, min_d, max_d,
                             additional_extent_lower, additional_extent_upper)
            return

        # Otherwise carry on updating the existing tree structure
        
        was_paused = is_leaf and node.is_pure()
        node.update(data, labels)
        is_paused = is_leaf and node.is_pure()

        if was_paused and not is_paused:
            # We've unpaused a leaf node so we need to grow the tree
            self._grow(node)
        elif not is_leaf:
            # Split the data into left portion and right portion, and repeat
            # whole process with node's children
            goes_left = node.apply_split(data)
            if sum(goes_left):
                self._extend_node(node.left, data[goes_left], labels[goes_left])
            if sum(~goes_left):
                self._extend_node(node.right, data[~goes_left], labels[~goes_left])


    @jit
    def _split_node(self, node, data, labels, split_cost, min_d, max_d,
                    additional_extent_lower, additional_extent_upper):
        
        assert not node.is_leaf() # Mutate leaf nodes by growing, not splitting
        
        # Create new parent node which is a near-copy of the one that's splitting
        new_parent = MondrianNode(self.n_dims, self.n_labels, node.parent, budget=node.budget)
        new_parent.min_d = np.minimum(min_d, node.min_d)
        new_parent.max_d = np.maximum(max_d, node.max_d)
        new_parent.range_d, new_parent.sum_range_d = get_data_range(new_parent.min_d, new_parent.max_d)
        new_parent.label_counts = node.label_counts
        
        # Pick a random dimension to split on
        feat_score = additional_extent_lower + additional_extent_upper
        feat_id = sample_multinomial_scores(feat_score)
        
        # Pick a random split point between previous bounding box and new one
        draw_from_lower = np.random.rand() <= (additional_extent_lower[feat_id] / feat_score[feat_id])
        if draw_from_lower:
            split = random.uniform(min_d[feat_id], node.min_d[feat_id])
        else:
            split = random.uniform(node.max_d[feat_id], max_d[feat_id])
        
        assert (split < node.min_d[feat_id]) or (split > node.max_d[feat_id])
        
        # Set up the new parent node to use this split
        new_parent.split_dim = feat_id
        new_parent.split_point = split
        
        # Now create new child node which is initially empty -- new sibling for original node
        new_budget = node.budget - split_cost
        new_sibling = MondrianNode(self.n_dims, self.n_labels, new_parent, budget=new_budget)
        
        # This bit's clever -- since the split point is outside the original node's bounding box,
        # we might need to give some new data to that node, but we won't need to take any away
        # from the existing node. By definition, none of its data points can be in there.
        
        # Use the new parent's split criterion to decide which child gets which subset of data,
        # and adjust tree to match
        goes_left = new_parent.apply_split(data)
        original_node_goes_left = split > node.max_d[feat_id]
        if original_node_goes_left:
            new_parent.left = node
            new_parent.right = new_sibling
            data_for_original = goes_left
        else:
            new_parent.left = new_sibling
            new_parent.right = node
            data_for_original = ~goes_left

        # Figure out whether new parent is on the left or right of *its* parent (unless it's the root)
        if node == self.root:
            self.root = new_parent
        else:
            if node.parent.left == node:
                node.parent.left = new_parent
            elif node.parent.right == node:
                node.parent.right = new_parent
            else:
                assert False
        node.parent = new_parent
        
        # Update budgets and costs associated with the nodes
        node.budget = new_budget
        node.max_split_cost -= split_cost
        new_parent.max_split_cost = split_cost
        
        # Update the bounding boxes and label counts for the left and right sides of the new split
        # (the new node will be grown automatically when needed, filling in max_split_cost)
        if sum(data_for_original) > 0:
            self._extend_node(node.left, data[data_for_original], labels[data_for_original])
        if sum(~data_for_original) > 0:
            self._extend_node(node.right, data[~data_for_original], labels[~data_for_original])
        
        # TODO ensure the new node behaves correctly (i.e. gets grown when it needs to)


    @jit
    def _grow(self, node):
        
        assert node.is_leaf()
        
        # Is node paused, empty or effectively empty? If so, don't split it
        if node.is_pure() or node.sum_range_d == 0:
            node.max_split_cost = node.budget
            return

        split_cost = random.expovariate(node.sum_range_d)
        node.max_split_cost = split_cost

        if node.budget > split_cost:
            node.split_dim = sample_multinomial_scores(node.range_d)
            node.split_point = random.uniform(node.min_d[node.split_dim], node.max_d[node.split_dim])
            
            # TODO use the default budget here, or inherit from parent? Paper says default
            node.left = MondrianNode(self.n_dims, self.n_labels, node)
            node.right = MondrianNode(self.n_dims, self.n_labels, node)
            # No point growing these as they start off empty (unlike in original paper)


    @jit
    def predict(self, row):
        # Dumb-ass scoring, just for now
        node = self.root
        last_counts_seen = node.label_counts
        while node.label_counts.sum() > 0 and not node.is_leaf():
            last_counts_seen = node.label_counts
            left = node.apply_split(row)
            node = node.left if left else node.right
        # FIXME why do we sometimes get tiny floats in here, when they should be just counts (ints)?
        if np.allclose(last_counts_seen, 0):
            return np.zeros_like(last_counts_seen)
        # L1 normalize
        return last_counts_seen / last_counts_seen.sum()


@jit
class MondrianForest(object):
    
    def __init__(self, n_trees, n_dims, n_labels, budget):
        self.trees = [MondrianTree(n_dims, n_labels, budget) for k in range(n_trees)]
    
    @jit
    def update(self, data, labels):
        for tree in self.trees:
            tree.extend(data, labels)
    
    @jit
    def predict(self, row, aggregate):
        results = [tree.predict(row) for tree in self.trees]
        stacked = np.vstack(results)
        if aggregate:
            return stacked.sum(axis=0) / stacked.sum()
        else:
            return stacked

    # No longer needed?
    def _repeat(self, arg):
        return (arg for i in range(len(self.trees)))

