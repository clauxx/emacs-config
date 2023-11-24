(defcustom cl/leader "SPC"
  "Global prefix used in `general' keybindings."
  :type 'string)

(defcustom cl/beta-leader "S-SPC"
  "Global prefix used in `general' keybindings for buffer commands."
  :type 'string)

(defcustom cl/sigma-leader ","
  "Global prefix used in `general' keybindings for language specific commands."
  :type 'string)

(define-minor-mode cl/keys-mode
  "Personal keybindings."
  :init-value t
  :lighter " MK"
  :global t
  :keymap '())

(defvar cl/core-location
  "elisp/core/"
  "Location of the core config")

(defvar cl/packages-location
  "elisp/packages/"
  "Location of the emacs packages")

(defvar cl/languages-location
  "elisp/languages/"
  "Location of the language configs")

(defvar cl/themes-location
  "elisp/themes/"
  "Location of the emacs custom themes")

(provide 'globals)
