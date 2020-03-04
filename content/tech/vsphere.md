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
