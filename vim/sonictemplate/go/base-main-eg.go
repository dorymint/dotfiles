package main

import (
	"flag"
	"fmt"
	"io"
	"os"
)

var (
	Name = "{{_expr_:expand("%:p:h:t")}}"
	Version = "0.0.0"
)

// example and comment for print usage
type Examples []struct {
	c string
	e string
}

func (es *Examples) Sprint() string {
	var s string
	for _, e := range *es {
		s += fmt.Sprintf("  %s\n", e.c)
		s += fmt.Sprintf("  $ %s\n\n", e.e)
	}
	return s
}

// append flag -example and trim from -help?
var examples = &Examples{
	{
		c: "Display help message",
		e: Name + " -help",
	},
}

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
		fmt.Fprintf(*w, "Examples:\n%s", examples.Sprint())
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

func run() error {
	var usageWriter io.Writer = os.Stderr
	usage := makeUsage(&usageWriter)
	flag.Usage = usage

	flag.Parse()
	if flag.NArg() != 0 {
		flag.Usage()
		return fmt.Errorf("invalid arguments: %v", flag.Args())
	}

	switch {
	case opt.help:
		usageWriter = os.Stdout
		flag.Usage()
		return nil
	case opt.version:
		fmt.Printf("%s %s\n", Name, Version)
		return nil
	}

	// do

	return fmt.Errorf("not implemented")
}

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
