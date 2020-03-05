---

title: "vSphere"
description: >
  All I've learned about/from VMWare's vSphere.
categories: ["virtualization", "technology"]

---

- I got to learn about Datacenter and Virtualization technology professionally when I started working @gojek
- vSphere is a cloud computing platform built on top of VMWare's ESXi virtualization.
- It connects to ESXi (bare metal) hosts and manages virtualized (VM) workloads on top of those hosts in a clustered manner.
- It provides many features to handle workloads:
  - Resource accounting (quota, limits, shares) of compute resources.
  - High Availability
    - Can reschedule VMs to other ESXi host in case of failure.
    - Fault tolerance -> active-passive mechanism.
    - vMotion -> a cool feature which "snapshots" the VMs to its memory and scheduled CPU execution to other passive "VM" in other ESXi host.
  - Hot adding cpu/memory.
  - Integration with VMWare's SDN platform, NSX-T.
- The API is somewhat hard to use.
  - Probably intended, so users will seek for enterprise/professional support.

## Extending VM Disk Space

Kinda like AWS EC2's EBS, we can extend the disk space of a VM in real-time without needing to reboot the machine. I used vSphere v6.5.
Here's how:

1. Right click on the VM, and choose "Edit Settings"
2. In the "Hard Disk" item, just fill in the size we want the disk to have.
3. Get into the machine's console, and find out which device is the Hard Disk; run:
   ```shell
    $ df -h

    # in my case, I have /dev/sda2
    Filesystem      Size  Used Avail Use% Mounted on
    ...
    /dev/sda2        32G   20G   11G  65% /
    ...

    $ lsblk

    NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    ...
    sda      8:0    0  200G  0 disk
    ├─sda1   8:1    0    1M  0 part
    └─sda2   8:2    0  200G  0 part /
    ...
   ```
4. We'll grow the partition /dev/sda2 to extend the partition's space, and extend the filesystem's space:
   ```shell
    $ sudo growpart /dev/sda 2
    CHANGED: partition=2 start=4096 old: size=67104735 end=67108831 new: size=419426271 end=419430367

    $ sudo resize2fs /dev/sda2
    resize2fs 1.45.5 (07-Jan-2020)
    Filesystem at /dev/sda2 is mounted on /; on-line resizing required
    old_desc_blocks = 4, new_desc_blocks = 25
    The filesystem on /dev/sda2 is now 52428283 (4k) blocks long
   ```
5. We have resized our partition. To confirm, run:
   ```shell
    $ df -h
    Filesystem      Size  Used Avail Use% Mounted on
    ...
    /dev/sda2       197G   20G  170G  11% /
    ...
   ```
6. Done!