#lang racket/base
(require file/tar
         file/gzip
         racket/file)

(module test racket/base)

(define origin-dir (build-path "build" "origin"))

(make-directory* origin-dir)

(define tgz-file
  (path->complete-path (build-path origin-dir "collects.tgz")))

(when (file-exists? tgz-file)
  (delete-file tgz-file))

(parameterize ([current-directory (build-path "racket")])
  (tar-gzip tgz-file "collects"
            ;; Skip "." files:
            #:path-filter (lambda (p)
                            (define-values (base name dir?) (split-path p))
                            (not (regexp-match? #rx"^[.]" name)))))
