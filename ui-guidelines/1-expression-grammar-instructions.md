# SAIL Expression Grammar and Syntax Reference

## ⚠️ Critical Syntax Rules

### 1. Logical Operators (Functions Only)
**WRONG:** `if(a and b, ...)` or `if(a or b, ...)`  
**RIGHT:** `if(and(a, b), ...)` or `if(or(a, b), ...)`

SAIL does not support `and`/`or` as infix operators. Always use function syntax: `and(condition1, condition2, ...)` and `or(condition1, condition2, ...)`

### 2. Local Variable Reuse
**WRONG:** `a!localVariables(local!x: 1, local!x: 2)`  
**RIGHT:** `a!localVariables(local!x: 1, local!y: 2)`

### 3. save!value Usage
**WRONG:** `saveInto: if(save!value, a!save(...), {})`  
**RIGHT:** `saveInto: a!save(value: if(save!value, newVal, oldVal))`

### 4. String Escaping
**WRONG:** `"He said, \"Hello\"."`  
**RIGHT:** `"He said, ""Hello""."`

Use double quotes (`""`) to escape quotes, not backslash (`\"`)

### 5. Comments
**WRONG:** `// This is a comment`  
**RIGHT:** `/* This is a comment */`

## Expression Grammar Structure

### Precedence Hierarchy (Lowest to Highest)
1. **Comparison expressions** (`=`, `<>`, `<`, `>`, `<=`, `>=`)
2. **String concatenation** (`&`)
3. **Arithmetic** (`+`, `-`, `*`, `/`)
4. **Exponential** (`^`)
5. **Unary** (`-`)
6. **Percentage** (`%` - divides by 100, NOT modulo)
7. **Primary expressions** (literals, variables, functions, etc.)

### Comparison Rules
- Text comparisons using `=` are case-insensitive
- Use `isnull()` for null checking instead of `= null`
- Comparisons should be between the same type (no automatic casting)
- Arithmetic works on numbers and arrays: `{1,10}+3` returns `{4,13}`

## Function Categories

### Array Functions (Positional Parameters)

#### Core Array Operations
```sail
a!flatten(array)                    /* Flattens nested arrays */
append(array, value)                /* Appends value(s) to array */
index(array, index, default)        /* Gets array[index] or default */
insert(array, value, index)         /* Inserts value at index */
length(array)                       /* Returns array length */
reverse(array)                      /* Reverses array order */
remove(array, index)                /* Removes value at index */
updatearray(array, index, value)    /* Updates value at index */
```

#### Array Search and Filter
```sail
where(booleanArray)                 /* Returns indices where true */
wherecontains(valuesToFind, arrayToFindWithin)  /* Find positions */
merge(array1, array2, ...)          /* Merges arrays by position */
```

### Array Set Functions
```sail
contains(arrayToFindWithin, valueToFind)        /* Check if contains */
difference(array1, array2)                      /* Items in 1 not in 2 */
intersection(array1, array2)                    /* Items in both */
union(array1, array2)                          /* All unique items */
symmetricdifference(array1, array2)            /* Items not in both */
```

### Array Functions (Keyword Parameters)
```sail
a!update(data: value, index: indexArray, value: newValue)  /* Update at indices */
```

### Text Functions

#### String Manipulation
```sail
concat(text1, text2, ...)           /* Concatenate strings */
left(text, numChars)                /* Left substring */
right(text, numChars)               /* Right substring */
mid(text, startNum, numChars)       /* Middle substring */
len(text)                           /* String length */
find(searchText, withinText, startNum)  /* Find position (case sensitive) */
search(findText, withinText, startNum)  /* Find position (case insensitive) */
substitute(baseText, textToReplace, replacement)  /* Replace text */
split(text, separator)              /* Split into array */
```

#### String Formatting
```sail
upper(text)                         /* Convert to uppercase */
lower(text)                         /* Convert to lowercase */
proper(text)                        /* Proper case */
trim(text)                          /* Remove extra spaces */
clean(text)                         /* Remove non-printable chars */
```

#### Advanced Text Functions
```sail
extract(text, startDelimiter, endDelimiter)     /* Extract between delimiters */
like(text, pattern)                             /* Pattern matching (?, *, []) */
soundex(text)                                   /* Phonetic similarity code */
fixed(number, decimals, noCommas)               /* Format number as text */
text(value, format)                             /* Format with currency, date, etc. patterns */
```

### Date and Time Functions

#### Date Construction
```sail
date(year, month, day)              /* Create date */
datetime(year, month, day, hour, minute, second)  /* Create datetime */
time(hour, minute, second, millisecond)  /* Create time */
today()                             /* Current date */
now()                               /* Current datetime */
```

#### Date Extraction
```sail
year(date)                          /* Extract year */
month(date)                         /* Extract month */
day(date)                           /* Extract day */
hour(time)                          /* Extract hour */
minute(time)                        /* Extract minute */
second(time)                        /* Extract second */
weekday(date, returnType)           /* Day of week */
weeknum(date, methodology)          /* Week number */
```

#### Date Calculations
```sail
edate(startDate, months)            /* Add/subtract months */
eomonth(startDate, months)          /* End of month */
workday(startDate, days, holidays)  /* Add work days */
networkdays(startDate, endDate, holidays)  /* Count work days */
```

### Mathematical Functions

#### Basic Math
```sail
abs(number)                         /* Absolute value */
ceiling(number, significance)       /* Round up */
floor(number, significance)         /* Round down */
round(number, digits)               /* Round to digits */
int(number)                         /* Round down to integer */
power(base, exponent)               /* Exponentiation */
sqrt(number)                        /* Square root */
```

#### Advanced Math
```sail
sum(numberArray)                    /* Sum of array */
product(numberArray)                /* Product of array */
mod(dividend, divisor)              /* Remainder (modulo) */
rand()                              /* Random number */
enumerate(n)                        /* Returns {0,1,2...n-1} */
```

### Logical Functions

#### Boolean Operations
```sail
and(value1, value2, ...)            /* Logical AND (short-circuits) */
or(value1, value2, ...)             /* Logical OR (short-circuits) */
not(booleanValue)                   /* Logical NOT */
true()                              /* Boolean true */
false()                             /* Boolean false */
```

#### Conditional Logic
```sail
if(condition, valueIfTrue, valueIfFalse)        /* Conditional (short-circuits) */
choose(index, choice1, choice2, ...)            /* Select by index */
a!match(value: val, equals: test1, then: result1, equals: test2, then: result2, default: defaultResult)
```

### Conversion Functions

#### Type Casting
```sail
tostring(value)                     /* Convert to text */
tointeger(value)                    /* Convert to integer */
todecimal(value)                    /* Convert to decimal */
toboolean(value)                    /* Convert to boolean */
todate(value)                       /* Convert to date */
todatetime(value)                   /* Convert to datetime */
```

#### Special Conversions
```sail
cast(typeNumber, value)             /* Cast to specific type */
typeof(value)                       /* Get type number */
typename(typeNumber)                /* Get type name */
```

### Looping Functions

#### Iteration
```sail
a!forEach(items: array, expression: expr)      /* Iterate with fv!item, fv!index */
apply(function, array, context...)              /* Apply function to each item */
reduce(function, initial, list, context...)     /* Reduce array to single value */
```

Function variables available in `a!forEach`:
- `fv!item` - Current iteration item
- `fv!index` - Current iteration index (1-based)
- `fv!isFirst` - True for first item
- `fv!isLast` - True for last item
- `fv!itemCount` - Total count of items

#### Filtering
```sail
filter(predicate, array, context...)           /* Filter array by predicate */
reject(array, expression)                      /* Reject matching items */
all(predicate, array, context...)              /* All items match predicate */
any(predicate, array, context...)              /* Any item matches predicate */
none(predicate, array, context...)             /* No items match predicate */
```

### Statistical Functions
```sail
average(numberArray)                /* Mean average */
median(numberArray)                 /* Median value */
mode(numberArray)                   /* Most frequent value */
max(numberArray)                    /* Maximum value */
min(numberArray)                    /* Minimum value */
stdev(numberArray)                  /* Standard deviation (sample) */
stdevp(numberArray)                 /* Standard deviation (population) */
var(numberArray)                    /* Variance (sample) */
varp(numberArray)                   /* Variance (population) */
```

### Informational Functions
```sail
isnull(value)                       /* Check for null */
a!isNullOrEmpty(value)              /* Check for null or empty */
a!isNotNullOrEmpty(value)           /* Check for not null and not empty */
a!defaultValue(value, default)      /* Return first non-null/empty */
error(message)                      /* Throw exception */
```

## Text Formatting Patterns

### Date Formatting (for `text()` function)
```sail
/* Common date formats */
text(date(2020, 2, 27), "mm/dd/yyyy")          /* 02/27/2020 */
text(date(2020, 2, 27), "mmmm d, yyyy")        /* February 27, 2020 */
text(date(2020, 2, 27), "dddd")                /* Thursday */
text(datetime(2020, 2, 27, 15, 30), "h:mm AM/PM")  /* 3:30 PM */
```

### Number Formatting
```sail
/* Number formats */
text(1234.5, "##,###.##")                      /* 1,234.50 */
text(1234.5, "$####.##")                       /* $1234.50 */
text(0.50, "#%")                                /* 50% */
text(-3.434, "+0000.###;-0000.###")            /* -0003.434 */
```

## Variable Domains

### Common Variable Prefixes
- `local!` - Local variables (most common)
- `rule!` - Rule references
- `a!` - Appian functions
- `fv!` - Function variables (forEach, etc.)
- `save!` - Save context variables
- `cons!` - Constants
- `ri!` - Rule inputs
- `pv!` - Process variables

## Data Structures

### Arrays
```sail
{1, 2, 3, 4}                        /* Integer array */
{"a", "b", "c"}                     /* Text array */
{date(2020,1,1), today()}           /* Date array */
```

### Maps
```sail
a!map(
  id: "123",
  name: "John Doe",
  active: true()
)
```

### Dictionaries
```sail
{
  id: "123",
  name: "John Doe", 
  active: true()
}
```

## Validation Rules

### ✅ Required Syntax Rules
- Use function syntax for logical operations: `and()`, `or()`, `not()`
- Escape quotes with `""` not `\"`
- Use `/* */` for comments, not `//`
- All array indices are 1-based
- Use `mod()` function for modulo, not `%` operator (`%` divides by 100)

### ❌ Common Mistakes to Avoid
- JavaScript-style operators (`&&`, `||`, `!`)
- Empty parameters between commas in function calls
- Using `=` for null checking (use `isnull()`)
- Trying to use `and`/`or` as operators
- Backslash escaping in strings
- 0-based array indexing

### Mandatory Validation Checklist
- [ ] Expression starts with `a!localVariables()`
- [ ] Logical operations use functions: `and()`, `or()`, `not()`
- [ ] String quotes escaped with `""` not `\"`
- [ ] Comments use `/* */` syntax
- [ ] Array indices are 1-based
- [ ] No empty parameters in function calls
- [ ] Local variables use `local!` prefix

## Special Notes

### Arithmetic Behavior
- Operations work on both scalars and arrays: `{1,10}*3` returns `{3,30}`
- String concatenation uses `&` operator, not `+`
- Division by zero yields exception for scalars, infinity for arrays
- `%` is percentage (divide by 100), use `mod()` for remainder

### Type Behavior  
- Automatic type casting occurs in most operations
- Comparison operators are case-insensitive for text
- `exact()` function provides case-sensitive comparison
- Arrays automatically flatten in literals