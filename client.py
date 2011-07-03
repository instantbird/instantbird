#!/usr/bin/python

DEFAULT_INSTANTBIRD_REV = "default"

# URL of the default hg repository to clone for Mozilla.
DEFAULT_MOZILLA_REPO = 'http://hg.mozilla.org/releases/mozilla-release/'
DEFAULT_MOZILLA_REV = "FIREFOX_5_0_RELEASE"

# URL of the default hg repository to clone for inspector.
DEFAULT_INSPECTOR_REPO = 'http://hg.mozilla.org/dom-inspector/'
DEFAULT_INSPECTOR_REV = "default"

# URL of the default hg repository to clone for Venkman.
DEFAULT_VENKMAN_REPO = 'http://hg.mozilla.org/venkman/'
DEFAULT_VENKMAN_REV = "default"

import os
import sys
import datetime
from optparse import OptionParser

topsrcdir = os.path.dirname(__file__)
if topsrcdir == '':
    topsrcdir = '.'

try:
    from subprocess import call
    from subprocess import check_call
except ImportError:
    import subprocess
    def check_call(*popenargs, **kwargs):
        retcode = subprocess.call(*popenargs, **kwargs)
        if retcode:
            cmd = kwargs.get("args")
            if cmd is None:
                cmd = popenargs[0]
                raise Exception("Command '%s' returned non-zero exit status %i" % (cmd, retcode))

def check_call_noisy(cmd, *args, **kwargs):
    print "Executing command:", cmd
    check_call(cmd, *args, **kwargs)

def backup_cvs_venkman():
    """Backup (obsolete) Cvs checkout of Venkman.
    """

    venkmanpath = os.path.join(topsrcdir, 'mozilla', 'extensions', 'venkman')
    # Do nothing if there is no Venkman cvs directory.
    if not os.path.exists(os.path.join(venkmanpath, 'CVS')):
        return

    venkmancvspath = venkmanpath + '-cvs'
    print "Moving venkman to venkman-cvs..."
    try:
        os.rename(venkmanpath, venkmancvspath)
    except:
        # Print the exception without its traceback.
        sys.excepthook(sys.exc_info()[0], sys.exc_info()[1], None)
        sys.exit("Error: Venkman directory renaming failed!")

def do_hg_pull(dir, repository, hg, rev):
    fulldir = os.path.join(topsrcdir, dir)
    # clone if the dir doesn't exist, pull if it does
    if not os.path.exists(fulldir):
        fulldir = os.path.join(topsrcdir, dir)
        check_call_noisy([hg, 'clone', repository, fulldir])
    else:
        if options.verbose:
            cmd = [hg, 'pull', '-v', '-R', fulldir]
        else:
            cmd = [hg, 'pull', '-R', fulldir]
        if repository is not None:
            cmd.append(repository)
        check_call_noisy(cmd)
    # update to specific revision
    if options.clean:
        cmd = [hg, 'update', '-C', '-v', '-r', rev, '-R', fulldir]
    else:
        cmd = [hg, 'update', '-v', '-r', rev, '-R', fulldir]
    check_call_noisy(cmd)
    check_call([hg, 'parent', '-R', fulldir,
                '--template=Updated to revision {node}.\n'])

o = OptionParser(usage="client.py [options] checkout")
o.add_option("-m", "--instantbird-repo", dest="instantbird_repo",
             default=None,
             help="URL of Instantbird hg repository to pull from (default: use hg default in .hg/hgrc)")

o.add_option("-z", "--mozilla-repo", dest="mozilla_repo",
             default=None,
             help="URL of Mozilla repository to pull from (default: use hg default in mozilla/.hg/hgrc; or if that file doesn't exist, use \"" + DEFAULT_MOZILLA_REPO + "\".)")
o.add_option("--skip-instantbird", dest="skip_instantbird",
             action="store_true", default=False,
             help="Skip pulling the Instantbird repository.")
o.add_option("--instantbird-rev", dest="ib_rev",
             default=DEFAULT_INSTANTBIRD_REV,
             help="Revision of Instantbird repository to update to. Default: \"" + DEFAULT_INSTANTBIRD_REV + "\"")

o.add_option("--skip-mozilla", dest="skip_mozilla",
             action="store_true", default=False,
             help="Skip pulling the Mozilla repository.")
o.add_option("--mozilla-rev", dest="mozilla_rev",
             default=DEFAULT_MOZILLA_REV,
             help="Revision of Mozilla repository to update to. Default: \"" + DEFAULT_MOZILLA_REV + "\"")

o.add_option("--inspector-repo", dest="inspector_repo",
             default=None,
             help="URL of DOM inspector repository to pull from (default: use hg default in mozilla/extensions/inspector/.hg/hgrc; or if that file doesn't exist, use \"" + DEFAULT_INSPECTOR_REPO + "\".)")
o.add_option("--skip-inspector", dest="skip_inspector",
             action="store_true", default=False,
             help="Skip pulling the DOM inspector repository.")
o.add_option("--inspector-rev", dest="inspector_rev",
             default=DEFAULT_INSPECTOR_REV,
             help="Revision of DOM inspector repository to update to. Default: \"" + DEFAULT_INSPECTOR_REV + "\"")

o.add_option("--venkman-repo", dest = "venkman_repo",
             default = None,
             help = "URL of Venkman repository to pull from (default: use hg default in mozilla/extensions/venkman/.hg/hgrc; or if that file doesn't exist, use \"" + DEFAULT_VENKMAN_REPO + "\".)")
o.add_option("--skip-venkman", dest="skip_venkman",
             action="store_true", default=False,
             help="Skip pulling the Venkman repository.")
o.add_option("--venkman-rev", dest = "venkman_rev",
             default = DEFAULT_VENKMAN_REV,
             help = "Revision of Venkman repository to update to. Default: \"" + DEFAULT_VENKMAN_REV + "\"")

o.add_option("--hg", dest="hg", default=os.environ.get('HG', 'hg'),
             help="The location of the hg binary")
o.add_option("-v", "--verbose", dest="verbose",
             action="store_true", default=False,
             help="Enable verbose output on hg updates")
o.add_option("-C", "--clean", dest="clean",
             action="store_true", default=False,
             help="Override local modifications when upgrading")

backup_cvs_venkman()

def fixup_repo_options(options):
    """ Check options.instantbird_repo and options.mozilla_repo values;
    populate mozilla_repo if needed.

    options.instantbird_repo and options.mozilla_repo are normally None.
    This is fine-- our "hg pull" commands will omit the repo URL.
    The exception is the initial checkout, which does an "hg clone"
    for Mozilla.  That command requires a repository URL.
    """

    if (options.instantbird_repo is None
        and not options.skip_instantbird
        and not os.path.exists(os.path.join(topsrcdir, '.hg'))):
        o.print_help()
        print
        print "*** The -m option is required for the initial checkout."
        sys.exit(2)

    # Handle special case: initial checkout of Mozilla.
    if (options.mozilla_repo is None
            and not os.path.exists(os.path.join(topsrcdir, 'mozilla'))):
        options.mozilla_repo = DEFAULT_MOZILLA_REPO

    # Handle special case: initial checkout of inspector.
    if (options.inspector_repo is None
            and not os.path.exists(os.path.join(topsrcdir, 'mozilla', 'extensions', 'inspector'))):
        options.inspector_repo = DEFAULT_INSPECTOR_REPO

    # Handle special case: initial checkout of Venkman.
    if (options.venkman_repo is None
            and not os.path.exists(os.path.join(topsrcdir, 'mozilla', 'extensions', 'venkman'))):
        options.venkman_repo = DEFAULT_VENKMAN_REPO

try:
    (options, (action,)) = o.parse_args()
except ValueError:
    o.print_help()
    sys.exit(2)

fixup_repo_options(options)

if action in ('checkout', 'co'):
    if not options.skip_instantbird:
        do_hg_pull('.', options.instantbird_repo, options.hg, options.ib_rev)

    if not options.skip_mozilla:
        do_hg_pull('mozilla', options.mozilla_repo, options.hg, options.mozilla_rev)
        check_call_noisy("bash tools/patches/apply-patches.sh", shell=True)

    # Check whether destination directory exists for these extensions.
    if (not options.skip_inspector or not options.skip_venkman) and \
       not os.path.exists(os.path.join(topsrcdir, 'mozilla', 'extensions')):
        # Don't create the directory: Mozilla repository should provide it...
        print >>sys.stderr, "Warning: mozilla/extensions directory does not exist; DOM Inspector and/or Venkman could not be checked out."
        # Abort checking out dependent extensions.
        options.skip_inspector = \
        options.skip_venkman = \
            True

    if not options.skip_inspector:
        do_hg_pull(os.path.join('mozilla', 'extensions', 'inspector'), options.inspector_repo, options.hg, options.inspector_rev)

    if not options.skip_venkman:
        do_hg_pull(os.path.join('mozilla', 'extensions', 'venkman'), options.venkman_repo, options.hg, options.venkman_rev)

else:
    o.print_help()
    sys.exit(2)
