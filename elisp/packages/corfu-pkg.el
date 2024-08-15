(use-package corfu
  :after evil
  :custom
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  (corfu-auto t)
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin
  :bind (:map corfu-map
              ("M-j" . corfu-next)
              ("TAB" . corfu-next)
              ("M-k" . corfu-previous)
              ("§" . corfu-previous))
  :config
  (corfu-popupinfo-mode)
  (advice-add 'corfu--setup :after (lambda (&rest _) (evil-normalize-keymaps)))
  (advice-add 'corfu--teardown :after (lambda (&rest _) (evil-normalize-keymaps)))
  :init
  (global-corfu-mode))

(provide 'corfu-pkg)
