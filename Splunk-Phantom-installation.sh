#!/bin/bash

<<Longcommet

Install Splunk Phantom as an unprivileged user
Tar file distributions of Splunk Phantom are available for installations where Splunk Phantom will run as an unprivileged user.

Before you install Splunk Phantom as an unprivileged user, the root user or a user with sudo access must prepare the system.

Do all these tasks with root permissions, either by logging in as root or as a user with sudo permission.

Install the operating system dependencies
Do all these tasks with root permissions, either by logging in as root or as a user with sudo permission

Longcommet

#Edit /etc/selinux/config to disable SELinux. Change the SELINUX= entry to:
SELINUX=disabled

#Clear yum caches.
yum clean all
