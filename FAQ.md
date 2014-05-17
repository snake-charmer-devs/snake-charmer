# Snake Charmer

## Frequently Asked Questions

### Why is the virtual machine called charmed34?

"34" is the 3.4 from Python 3.4, without the decimal point. And "charmed"
as in snake charmers.

The plan is to offer a number of different VMs with different Python versions.

### Why does Snake Charmer use virtual machines, rather than just installing all its components in a virtualenv?

Some packages don't play well with virtualenv. Also, there are always
dependencies on the underlying operating system, or on libraries installed via
its native package management. These differences can't be contained within a
virtualenv.

One of the primary goals of Snake Charmer is reproducibility. It lets you build
environments that are guaranteed to behave the same way no matter what machine
you are using.

Another goal is portability. A Snake Charmer VM can be duplicated, and
redeployed on another machine -- or a whole cluster of machines.

Virtual machines are the easiest way to achieve these goals. They also allow us
to include non-Python components like R -- this would be impossible in a
virtualenv.

Plus you get all the benefits of Vagrant, such as being able to share machines
over Vagrant Cloud, and repackage them as new boxes.

Finally, VMs allow you to set resource usage limits (e.g. on RAM and CPU) that
can prevent runaway processes from rendering a machine unusable.

### What are the advantages of Snake Charmer over Anaconda, Canopy or Sage?

Anaconda and Canopy are Scientific Python distributions providing free
editions, but they are dependent on the support of a commercial organisation.
None of the advantages of VMs described above apply to these distros. Sage is
open source, run by a non-profit, and available as a VM, but is quite academic
and focused largely on pure maths.

Also, Snake Charmer aims to provide more up-to-date software -- in fact, this
is a key goal. At the time of writing, neither Sage nor Canopy support Python 3
at all, and Anaconda doesn't support 3.4. Package versions are similarly
limited.

### Are Snake Charmer VMs slow?

Virtualization incurs a small overhead, but with modern hardware, this isn't
usually a major factor. Make sure virtualization extensions are
[enabled in your BIOS](http://www.sysprobs.com/disable-enable-virtualization-technology-bios)
(most manufacturers do this by default these days).

### Can Snake Charmer VMs access my GPU?

**GPU computation using CUDA is not supported yet**. GPU virtualization is a
feature of some
[recent NVIDIA hardware](http://www.nvidia.com/object/dedicated-gpus.html)
but this is not yet possible in Python. _(As far as I know anyway...)_

### Can I run desktop GUI apps, like IPython Qt Console, or Tkinter apps?

Yes, but it's a bit fiddly. You can ssh into the VM using `vagrant ssh` and
start them from the command line, and they'll run as X11 apps, as if your VM
was a remote Linux server. However, Windows users will need to install an X
server such as [Xming](http://sourceforge.net/projects/xming/) in order to do
this.

### Are Snake Charmer VMs secure?

#### No.

The default username and password `vagrant`/`vagrant` is the same for most
Vagrant boxes, as is the insecure private key used for passwordless
authentication. And even if you don't put any sensitive data into your VM,
there [may still be ways](http://blog.ontoillogical.com/blog/2012/10/31/breaking-in-and-out-of-vagrant/)
to get access to the host from the guest. (We have closed that particular
loophole but can't guarantee there aren't others.)

In short, only use it on trusted networks.

Tightening security in Snake Charmer would be very useful indeed -- any volunteers?

### How can I connect to the VM by passwordless SSH from an application or script?

This may be useful if you want to set up an IPython cluster of VMs on different
machines, for example. Snake Charmer automatically forwards port 22NN on the
host to port 22 (SSH) on the VM, where NN is the 2-digit Python version code.
e.g. the `charmed34` VM will listen for incoming ssh on port 2234.

To connect to this port via ssh programmatically, use `vagrant` for the
username, and use the default `insecure_private_key` that vagrant ships with.
Type `vagrant ssh-config` to check where this is on your system.

Basically everything on the VM happens as this user.

### How can I connect to other ports on the VM, apart from SSH and the Notebook webserver?

Normally you would need to edit the Vagrantfile in order to do this, but if you
can change the port that the process listens on, you can do it more easily.

The Vagrantfile sets up 10 ports that are automatically forwarded from the host
to the VM, numbered 90NN, 91NN, 92NN ... 99NN -- where NN is the 2-digit Python
version code. e.g. the `charmed34` VM will automatically forward ports 9034,
9134, 9234 ... 9934.

If you have flexibility over what port to listen on, just use one of those, and
any connections to the host on that port will get forwarded automatically.

For example, you might want to start a simple webserver on port 9034:

```python
import SimpleHTTPServer
import SocketServer

PORT = 9034

Handler = SimpleHTTPServer.SimpleHTTPRequestHandler

httpd = SocketServer.TCPServer(("", PORT), Handler)

print "serving at port", PORT
httpd.serve_forever()
```

Connecting to port 9034 on the host will attach to this webserver on the VM.

