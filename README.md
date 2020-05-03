# vim-plantuml-helpers

The Vim plugin that makes editing of the Plantuml files more efficient.

## Installation
The plugin can be installed via minpac or by cloning the repository to the vim plugin location.

### Via minpac
Add the following to the ~/.vimrc (provided the minpac is already installed and running:

```
call minpac#add('temper-rb/vim-plantuml-helpers')
```
Then in vim invoke
```
:call minpac#update()
```
### Via git clone
```
cd ~/.vim/<your_plugin_directory>
git clone git@github.com:temper-rb/vim-plantuml-helpers.git
```

## Usage
Once the plugin is installed one can use the vim help:
```
:h PlantumlHelpers
```

Since the plugin is in the early stage of the development it supports only limited
set op operations:

### Mirror association  
Mirror association is an operation where the sides of the UML associations are
swapped, but the association attributes are preserved at the association side.

Consider the following example:

Class1 "1" *-- "1..n" Class2

It defines the composition association of the type 1 to many between the Class1
and the Class2. When rendered by Plantuml, the Class1 will be placed on top of
the Class2.
Suppose now that one wants to have the Class2 be placed on top of the Class1.
That would require the specification like so:

Class2 "1..n" --* "1" Class1

The Command *:MirrorAssoc* does exactly that - it swaps the sides of the
association and preserves the association attributes. 
To mirror the association place the cursor in the line where the association 
is defined and invoke the command :MirrorAssoc.
Invoking the :MirrorAssoc again reverses the operation.


