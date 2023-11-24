(use-package detached
  :demand t
  :init
  (detached-init)
  :bind (([remap async-shell-command] . detached-shell-command))
  :custom ((detached-show-output-on-attach t)
           (detached-terminal-data-command system-type)))

(provide 'detached-pkg)
