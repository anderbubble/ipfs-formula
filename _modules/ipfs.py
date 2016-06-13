import grp
import logging
import os
import pwd
import subprocess

log = logging.getLogger(__name__)


def demote (user, group):
    if group is not None:
        os.setgid(grp.getgrnam(group).gr_gid)
    if user is not None:
        os.setuid(pwd.getpwnam(user).pw_uid)


def init (name, user=None, group=None):
    args = ['ipfs', 'init']
    env = os.environ.copy()
    env['IPFS_PATH'] = name
    subprocess.check_call(args, env=env, preexec_fn=lambda: demote(user, group))


def show_config (name, user=None, group=None):
    args = ['ipfs', 'config', 'show']
    env = os.environ.copy()
    env['IPFS_PATH'] = name
    subprocess.check_call(args, env=env, preexec_fn=lambda: demote(user, group))
