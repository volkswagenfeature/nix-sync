# Setup is as follows:
#
# secure terminal: built-from-scratch [st](https://st.suckless.org/)
# Maybe rip out the $PATH logic, and compile in a few vetted paths
# Password store: [pass](https://www.passwordstore.org/)
# with [pass-tomb](https://github.com/roddhjav/pass-tomb#readme)
# with [passff](https://github.com/passff/passff#readme)
#      Caution, may leak entire db to ff process. if that happens,
#      I have to build a secure browser for login, which isn't really
#      possible. Make sure it's sending the URL to pass, then having
#      the pass host process check if there are any secrets that match
#      that script.
# with [password-store](https://git.zx2c4.com/password-store/tree/contrib/dmenu)
#      What does this do exactly? 
#
# System git is probably going to be used. Attack surface can be decreased by
# using a vetted config file passed with --file.
# System bash is also probably going to be used. 
# Due to these, it's probably nessicary to use systemd-nspawn to avoid leakage.

# Security model:
# My primary model here is to resist trackers that are running as unwanted
# programs in user-space, and wanted loggers (ff hixtory, fish history) 
# That might be problematic from a forensic perspective. 


# Attack surface:
# I'm mostly building this out to resist supply chain attacks. The dependencies
# all have tiny codebases and are built from scratch with that in mind.
#
# However, a keylogging or screenlogging app should probably also be considered.
# There's discussion on how to pull this off on [Linuxsecurity.com](https://linuxsecurity.com/features/complete-guide-to-keylogging-in-linux-part-1)
# Without administrator access, this seems hard to prevent. With admin access,
# I may be able to grab keycodes directly, and bundle in the libs to interpret
# them directly. This would leave me resistant to keyloggers above the kernel 
# level. That might not work though.

# I have to look into the kernel -> wayland -> sway -> userapps pipe to 
# see how the keycodes might get grabbed. 

{
  stdenv,

  # st deps


}:
let
  secure_st 
in
{

}
 
