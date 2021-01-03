# Command Access Control List (command-acl.lua)

This class extends the acl.lua class, and is primarily used by commands for controlling access by users

Command ACL implements three criteria for permission checking

These are the criteria, listed in descending order of checking:
- User access 
- Role access
- Permission access

Each access level obeys the higher levels of access, the lowest being Permission access level. For example, if a given user doesn't have role permissions for executing a command, but they are allowed to use it on the user access level, they will be able to execute a command. Vice versa, if a given user has the permissions for using a command but they are restricted on the user level, they would **not** be able to execute that command.

An important note should be made about how role access is handled in this extension. Unlike the POSIX ACL system which the ACL class was inspired by, where it is only necessary to be a part of the permitted role to have access to a resource, this extension has a role hierarchy system, where role access is affected by the following conditions:

1. If a role has access to a command, and a different role is restricted from using that command, the one which is higher in the role list of the current user determines their access.
1. If a role has no rules for it (that does not imply default access), then it is ignored.

# Usage



