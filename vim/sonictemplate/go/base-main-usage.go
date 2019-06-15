package main

import (
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
)

const (
	Name    = `{{_expr_:expand('%:p:h:t')}}`
	Version = `0.1.0`
)

const usage = `Usage:
  {{_expr_:expand('%:p:h:t')}} [Options]

Options:
  -help Display this message

Examples:
  # help
  $ {{_expr_:expand('%:p:h:t')}} -help
`

var usageWriter io.Writer = os.Stderr

var opt struct {
	help    bool
	version bool
}

func init() {
	flag.BoolVar(&opt.help, "help", false, "Display this message")
	flag.BoolVar(&opt.version, "version", false, "Display version")
}

func run() (err error) {
	flag.Parse()
	switch {
	case opt.help:
		usageWriter = os.Stdout
		flag.Usage()
		return nil
	case opt.version:
		_, err = fmt.Printf("%s %s\n", Name, Version)
		return err
	}

	// TODO: impl

	return errors.New("not implemented")
}

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
