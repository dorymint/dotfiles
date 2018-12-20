func usage(w io.Writer, fl *flag.FlagSet, subMap map[string]string) error {
	const nspaces = 4
	const indent = "\t"
	str := `Usage of ` + fl.Name() + `:

OPTIONS:
`

	// OPTIONS
	type help struct {
		name string
		help string
	}
	var options struct {
		// length of flags name
		maxLen int
		helps  []help
	}
	fl.VisitAll(func(f *flag.Flag) {
		if n := len(f.Name); n > options.maxLen {
			options.maxLen = n
		}
		options.helps = append(options.helps, help{
			name: "-" + f.Name,
			help: fmt.Sprintf("%s (default %q)", f.Usage, f.DefValue),
		})
	})
	for _, help := range options.helps {
		str += fmt.Sprintf("%s%s%s%s\n", indent, help.name, strings.Repeat(" ", nspaces+options.maxLen-len(help.name)), help.help)
	}

	// SUBCOMMANDS
	if len(subMap) != 0 {
		var maxLen int
		var names []string
		for name := range subMap {
			if n := len(name); n > maxLen {
				maxLen = n
			}
			names = append(names, name)
		}
		sort.Strings(names)
		str += fmt.Sprintf("\nSUBCOMMANDS:\n")
		for _, name := range names {
			help := subMap[name]
			str += fmt.Sprintf("%s%s%s%s\n", indent, name, strings.Repeat(" ", nspaces+maxLen-len(name)), help)
		}
	}

	_, err := fmt.Fprintf(w, "%s\n", str)
	return err
}
