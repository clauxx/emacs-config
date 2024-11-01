(load-file
 (expand-file-name "elisp/globals.el" user-emacs-directory))

(defvar config-paths
  (list cl/core-location
	cl/packages-location
	cl/languages-location
	cl/themes-location
	cl/user-location))

(defvar user-pkgs '(wiky))

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
    project-config))

(defvar my-packages
  '(evil-pkg
    envrc-pkg
    emojify-pkg
    babashka-pkg
    org-pkg
    icons-pkg
    detached-pkg
    tabspaces-pkg
    gptel-pkg
    smartparens-pkg
    golden-ratio-pkg
    dashboard-pkg
    doom-modeline-pkg
    whichkey-pkg
    rainbow-pkg
    pandoc-pkg
    apheleia-pkg
    lsp-mode-pkg
    magit-pkg
    general-pkg
    vertico-pkg
    consult-pkg
    corfu-pkg
    orderless-pkg
    request-pkg
    ;; spacious-padding-pgk ;; Unused since looks weird with the Noir theme
    marginalia-pkg))

(defvar my-languages
  '(elisp-lang
    clojure-lang
    typescript-lang
    go-lang
    rust-lang
    nix-lang
    yuck-lang))

(defvar all-modules
  (append core-modules my-packages my-languages user-pkgs))

(dolist (path config-paths)
  (add-to-list 'load-path (expand-file-name path user-emacs-directory)))

(dolist (mod all-modules)
  (require mod))
