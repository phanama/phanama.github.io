---

title: "ansible"
description: >
  All I've learned about/from ansible.
categories: ["technology"]

---

_This is a living document specially crafted for my personal use_.

Go to [cheatsheet](#cheatsheet)

# About Ansible

Mental model:

- A tool that scaffolds scripts containing commands to be executed against machine(s).
- The main use case is to ssh to a bunch of remote machines and do commands on them via ssh.
  - Can be used against local machine too.
- Agentless, only need ssh enabled and python installed in the remote machines.
- Scaffolding is defined and standard.
- Using ansible modules, things can easily be indempotent.
  - Indempotent here means we can execute the same set of commands (in form of playbooks or tasks) multiple times with the same results.
- Using playbooks and roles we can make thing modular.
  - Can be made DRY.
- Jinja2 can be abused to template just anything without having to code Python.
  - Just follow the standard ansible convention.
  - Implementing it manually using python might lead to different implementations/behaviors.
    - e.g. impl a uses jinja2 template files stored anywhere in the filesystem, while impl b can just put the templates inside python variables.
    - Using ansible, the standard is there, just put into roles/templates/.
      - Then use the `template` module.
      - This standard means easier code sharing, as everyone knows the standard.
        - No need to crunch brainpower to re-learn varying standard anymore.
- Playbooks can be frustrating.
  - When they get so big, they're painfully slow.
    - Waiting for huge playbooks to finish when developing new playbooks is like waiting for C++ binaries to compile when developing C++ programs.
      - They're both painfully slow.
  - The output/errors can often be confusing.
    - To help with this, use the `stdout_callback = yaml` in the ansible.cfg
      - It makes the output at least pretier in YAML

# Cheatsheet

```bash

#overrides variables with the specified key=value
ansible-playbook playbook.yml -e key=value -e key2=value

#flush cache
ansible-playbook playbook.yml --flush-cache

#skip/include tags
ansible-playbook playbook.yml --tags TAG1,TAG2 --skip-tags TAG_NAME_TO_SKIP

```

## Send commands via bastion

```ini

[ssh_connection]
ssh_args = -o StrictHostKeyChecking=no -o ProxyCommand='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -W %h:%p USER@BASTION_IP -i ~/.ssh/id_rsa'

```

## Frequently Used Config

```ini

[ssh_connection]
pipelining=True
ssh_args = -o ControlMaster=auto -o ControlPersist=30m -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectionAttempts=100 -o ProxyCommand='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -W %h:%p USER@BASTION_IP -i ~/.ssh/id_rsa'

[defaults]

stdout_callback = yaml
callback_whitelist = profile_tasks
internal_poll_interval = 0.001
ansible_python_interpreter = /usr/bin/python3
forks = 50

host_key_checking=False
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp
deprecation_warnings=False

```

