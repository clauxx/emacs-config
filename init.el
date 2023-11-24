(add-to-list 'load-path (expand-file-name "elisp/core/" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "elisp/packages/" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "elisp/languages/" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "elisp/themes/" user-emacs-directory))

(defvar core-modules
  '(globals
    utils
    elpaca
    theme
    font
    custom
    emacs-config
    nixos-config
    keybindings
    ;;tabs-config
    project-config))

(defvar my-packages
  '(evil-pkg
    envrc-pkg
    org-pkg
    icons-pkg
    detached-pkg
    tabspaces-pkg
    smartparens-pkg
    golden-ratio-pkg
    dashboard-pkg
    whichkey-pkg
    rainbow-pkg
    pandoc-pkg
    apheleia-pkg
    lsp-mode-pkg
    ;;perspective-pkg
    magit-pkg
    general-pkg
    vertico-pkg
    consult-pkg
    corfu-pkg
    orderless-pkg
    marginalia-pkg))

(defvar my-languages
  '(elisp-lang
    clojure-lang
    go-lang
    nix-lang))

(defvar all-modules
  (append core-modules my-packages my-languages))

(dolist (mod all-modules)
  (require mod))
