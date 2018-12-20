flag.Parse()
if n := flag.NArg(); n == 1 {
	// TODO: default action
} else if n > 1 {
	// TODO: error handle
	flag.Usage()
	fmt.Fprintf(os.Stderr, "unknown arguments: %#v", flag.Args())
	os.Exit(1)
}
