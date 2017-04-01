// TODO: nyan: expr
eval := func(expr string) (types.TypeAndValue, error) {
	return types.Eval(token.NewFileSet(), types.NewPackage("main", "main"), token.NoPos, expr)
}
