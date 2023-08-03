# Determine whether the login account is root, if not, switch to the root account
if [ "$(id -u)" -ne 0 ]; then
    echo "Please use the 'root' account to log in (default password is 'root'), and re-run 'source /opt/tros/setup.bash'!" >&2
    su
fi
