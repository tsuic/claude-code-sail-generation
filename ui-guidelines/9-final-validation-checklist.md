# ‼️ MANDATORY Final Validation Checklist

AFTER generating the SAIL expression, you ‼️MUST‼️ run through this checklist of COMMON MISTAKES to find and fix any errors!

⚠️ Make ABSOLUTELY SURE that you've checked the following:
- [ ] NO sideBysideLayouts nested inside a sideBySideItem
- [ ] Only ONE component in each sideBySideItem
- [ ] DON'T use "MORE" or "LESS" for `spacing` - use "DENSE", "SPARSE", "STANDARD", or "NONE"
- [ ] DON'T use "MINIMIZE" for `columnLayout` `width` - it's only valid for `sideBySideItem`
- [ ] ALWAYS at least one "AUTO" `width` in each `columnsLayout`
- [ ] DON'T use "MEDIUM", "NARROW", etc. for `sideBySideItem` `width` - only "AUTO", "MINIMIZE", and "1X"–"10X" are valid
- [ ] Use the `or()` function, NOT the or operator