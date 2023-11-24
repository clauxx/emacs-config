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

(provide 'globals)
