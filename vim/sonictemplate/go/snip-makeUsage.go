// makeUsage:
// Name is name of executable
// Examples:
//	var usageWriter io.Writer = os.Stdout
//	flag.Usage = makeUsage(&usageWriter)
//	flag.Usage()
func makeUsage(w *io.Writer) func() {
	return func() {
		flag.CommandLine.SetOutput(*w)
		// two spaces
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
