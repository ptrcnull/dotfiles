function cpf() (
    (echo -n 'file://'; realpath $1) | wl-copy --type text/uri-list
)
