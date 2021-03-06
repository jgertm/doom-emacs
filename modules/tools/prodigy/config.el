;;; tools/prodigy/config.el -*- lexical-binding: t; -*-

(def-setting! :service (&rest plist)
  "TODO"
  `(after! prodigy
     (prodigy-define-service ,@plist)))


;;
;; Plugins
;;

(def-package! prodigy
  :commands (prodigy prodigy-view-mode prodigy-add-filter)
  :config
  (set! :evil-state 'prodigy-mode 'emacs)

  ;; Make services, etc persistent between Emacs sessions
  (doom-cache-persist
   :prodigy '(prodigy-services prodigy-tags prodigy-filters))

  (defun +prodigy*services (orig-fn &rest args)
    "Adds a new :project property to prodigy services, which hides the service
unless invoked from the relevant project."
    (let ((project-root (downcase (doom-project-root)))
          (services (apply orig-fn args)))
      (if current-prefix-arg
          services
        (cl-remove-if-not (lambda (service)
                            (let ((project (plist-get service :project)))
                              (or (not project)
                                  (file-in-directory-p project-root project))))
                          services))))
  (advice-add #'prodigy-services :around #'+prodigy*services)

  ;; Keybindings
  (map! :map prodigy-mode-map "d" #'+prodigy/delete))

