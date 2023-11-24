(use-package which-key
  :demand t
  :init
  (which-key-mode 1)
  :config
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 2
        which-key-max-display-columns nil
        which-key-min-display-lines 8
        which-key-side-window-slot -10
        which-key-side-window-max-height 0.3
        which-key-idle-delay 0.8
        which-key-max-description-length 25
        which-key-allow-imprecise-window-fit nil
        which-key-separator " → " ))

(provide 'whichkey-pkg)
