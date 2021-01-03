# ACL class (acl.lua)

ACL stands for Access Control List. It is a class that manages various properties for performing specific actions on objects. The framework uses this class mainly for checking whether a given user can call a command. 

The ACL class manages 2 out of 3 access levels described in Command ACL documentation - specifically, user access level and group access level.

ACL system was inspired by the POSIX ACL used widely by Unix and Unix-like operating systems.

# Usage

The ACL class itself isn't used in the framework - instead, a modified version of it (command-acl.lua), tailored for discord permission system is used. 

```lua


```


