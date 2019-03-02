package main

import (
	"flag"
	"fmt"
	"io"
	"os"
	"path/filepath"
)

var (
	// Name = "{{_expr_:expand("%:p:h:t")}}"
	Name    = filepath.Base(os.Args[0])
	Version = "0.0.0"
)

// Name string for specify command name
func makeUsage(w *io.Writer) func() {
	return func() {
		flag.CommandLine.SetOutput(*w)
		fmt.Fprintf(*w, "Description:\n")
		fmt.Fprintf(*w, "  Short description\n\n")
		fmt.Fprintf(*w, "Usage:\n")
		fmt.Fprintf(*w, "  %s [Options]\n\n", Name)
		fmt.Fprintf(*w, "Options:\n")
		flag.PrintDefaults()
		fmt.Fprintf(*w, "\n")
		examples := `Examples:
  $ ` + Name + ` -help # Display help message
`
		fmt.Fprintf(*w, "%s\n", examples)
	}
}

var opt struct {
	help    bool
	version bool
}

func init() {
	flag.BoolVar(&opt.help, "help", false, "Display this message")
	flag.BoolVar(&opt.version, "version", false, "Display version")
}

func main() {
	var usageWriter io.Writer = os.Stdout
	usage := makeUsage(&usageWriter)
	flag.Usage = usage
	flag.Parse()
	if flag.NArg() != 0 {
		usageWriter = os.Stderr
		flag.Usage()
		fmt.Fprintf(os.Stderr, "Invalid arguments: %v\n", flag.Args())
		os.Exit(1)
	}

	switch {
	case opt.help:
		flag.Usage()
		os.Exit(0)
	case opt.version:
		fmt.Printf("%s %s\n", Name, Version)
		os.Exit(0)
	}
}
