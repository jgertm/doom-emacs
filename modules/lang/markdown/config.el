;;; lang/markdown/config.el -*- lexical-binding: t; -*-

(def-package! markdown-mode
  :mode "/README$"
  :mode ("/README\\.md$" . gfm-mode)
  :mode "\\.m\\(?:d\\|arkdown\\)$"
  :init
  (setq markdown-enable-wiki-links t
        markdown-enable-math t
        markdown-italic-underscore t
        markdown-asymmetric-header t
        markdown-make-gfm-checkboxes-buttons t
        markdown-gfm-additional-languages '("sh")
        markdown-fontify-code-blocks-natively t
        markdown-hide-urls nil) ; trigger with `markdown-toggle-url-hiding'

  :config
  (defun +markdown|set-fill-column-and-line-spacing ()
    (setq-local line-spacing 2)
    (setq-local fill-column 80))
  (add-hook 'markdown-mode-hook #'+markdown|set-fill-column-and-line-spacing)
  (add-hook 'markdown-mode-hook #'auto-fill-mode)

  (map! (:map markdown-mode-map
          [remap find-file-at-point] #'markdown-follow-thing-at-point
          "M-*"      #'markdown-insert-list-item
          "M-b"      #'markdown-insert-bold
          "M-i"      #'markdown-insert-italic
          "M-`"      #'+markdown/insert-del
          :m "gj"    #'markdown-next-visible-heading
          :m "gk"    #'markdown-previous-visible-heading
          ;; Assumes you have a markdown renderer plugin in chrome
          :n "M-r"   #'browse-url-of-file
          ;; TODO: Make context sensitive
          :m "]h"    #'markdown-next-visible-heading
          :m "[h"    #'markdown-previous-visible-heading
          :m "[p"    #'markdown-promote
          :m "]p"    #'markdown-demote
          :m "[l"    #'markdown-next-link
          :m "]l"    #'markdown-previous-link
          :i "M--"   #'markdown-insert-hr

          (:localleader
            :nv "o" #'markdown-open
            :nv "b" #'markdown-preview
            (:prefix "i"
              :nv "t" #'markdown-toc-generate-toc
              :nv "i" #'markdown-insert-image
              :nv "l" #'markdown-insert-link)))))


(def-package! markdown-toc
  :commands markdown-toc-generate-toc)

