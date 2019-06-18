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
	Version = `0.0.0`
)

const usage = `Usage:
  {{_expr_:expand('%:p:h:t')}} [Options]

Options:
  -help    Display this message
  -version Display version

Examples:
  # help
  $ {{_expr_:expand('%:p:h:t')}} -help
`

var usageWriter io.Writer = os.Stderr

func printUsage() { fmt.Fprintln(usageWriter, usage) }

var opt struct {
	help    bool
	version bool
}

func init() {
	flag.BoolVar(&opt.help, "help", false, "Display this message")
	flag.BoolVar(&opt.version, "version", false, "Display version")
	flag.Usage = printUsage
}

func run() error {
	flag.Parse()
	switch {
	case opt.help:
		usageWriter = os.Stdout
		flag.Usage()
		return nil
	case opt.version:
		_, err := fmt.Printf("%s %s\n", Name, Version)
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
