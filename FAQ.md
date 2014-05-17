# Snake Charmer

## Frequently Asked Questions

### Why is the virtual machine called charmed34?

"34" is the 3.4 from Python 3.4, without the decimal point. And "charmed"
as in snake charmers.

The plan is to offer a number of different VMs with different Python versions.

### Can I share and distribute my Snake Charmer VMs via Vagrant Cloud?

Absolutely! We think this would be a great way to share experimental results
(reproducibly), foster international collaborations, publish data sets
interactively, and facilitate training, mentoring and learning.

For now, you'll have to refer to the
[sharing](http://docs.vagrantup.com/v2/share/index.html) and
[boxing](http://docs.vagrantup.com/v2/boxes.html) docs for more details, but
watch this space for Snake Charmer-centric tutorials later.

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

If you definitely need this feature, try the specialized Python distros
mentioned above.

### Can I run desktop GUI apps, like IPython Qt Console, or Tkinter apps?

Yes, but it's a bit fiddly. You can ssh into the VM using `vagrant ssh` and
start them from the command line, and they'll run as X11 apps, as if your VM
was a remote Linux server. However, Windows users (and OS X users, Mountain
Lion onward) will need to install an X server such as
[Xming](http://sourceforge.net/projects/xming/) or
[XQuartz](http://xquartz.macosforge.org) to make this work.

Plus no GUI frameworks are installed by default on the VMs -- it's a very
stripped-down server-oriented edition of Ubuntu.

### How can I connect to the VM by passwordless SSH from an application or script?

This may be useful if you want to set up an IPython cluster of VMs on different
machines, for example. Snake Charmer automatically forwards port 22NN on the
host to port 22 (SSH) on the VM, where NN is the 2-digit Python version code.
e.g. the `charmed34` VM will listen for incoming ssh on port 2234.

To connect to this port via ssh programmatically, use `vagrant` for the
username, and use the default `insecure_private_key` that vagrant ships with.
Type `vagrant ssh-config` to check where this is on your system.

Basically everything on the VM happens as this user.

**N.B.** As a token nod to security (see below), the SSH port forwarding on the
host computer only binds to 127.0.0.1 (localhost) by default. So an incoming
SSH connection from another machine would have to connect first to the host
(your physical computer) and then tunnel through to the VM. In the future,
there may be an option to disable this restriction, and expose the SSH port on
the VM to the whole world (at your own risk...).

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

Unlike the SSH and Notebook ports, these ports are intentionally _not_
protected from remote machines attaching to them, as a convenience for you --
but don't expose any vulnerable or sensitive services there and then come
running to us. No refunds...

### Are Snake Charmer VMs secure?

#### Not especially, no.

The default username and password `vagrant`/`vagrant` is the same for most
Vagrant boxes, as is the insecure private key used for passwordless
authentication. By default, the Notebook and SSH port forwarders only bind to
your computer's `localhost` address, making it slightly harder for someone to
own your VM over a network -- _in theory_, that means they'd need to be logged
onto your physical computer already. But it's not an insurmountable obstacle
for a dedicated attacker. Also, it's rather dependent on VirtualBox's
networking configuration, which tends to change from release to release.

And even if you don't put any sensitive data into your VM,
there [may still be ways](http://blog.ontoillogical.com/blog/2012/10/31/breaking-in-and-out-of-vagrant/)
to get access to the host from the guest. (We have closed that particular
loophole but can't guarantee there aren't others.)

In short, only use Snake Charmer on trusted networks.

Tightening security would be very useful indeed -- can you help?

### Can I run Snake Charmer on cloud services like AWS, or other virtualization platforms like VMWare?

In theory, yes, although probably not without some considerable work. In the
future, we'd like to be able to make that easy out-of-the-box.

