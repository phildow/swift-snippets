## Swift Snippets

Sublime Text like snippets on your NSTextView in Swift.

## License

Copyright (c) 2016 Philip Dow

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## About

A snippet is text that replaces an alphanumeric word when the tab key is pressed. It exapands the word to the snippet.

Snippets also support *fields*, which allow a user to continuing tabbing within the snippet to move the insertion point to predetermined locations in the snippet. Consequently a snippet is able to behave like a template with empty placeholders that are efficiently filled in.

**Sublime Text**

The insipration for this implementation comes from [Sublime Text](https://www.sublimetext.com/). Refer to the Sublime Text Snippets documentation for more information: [http://docs.sublimetext.info/en/latest/extensibility/snippets.html#snippet-features](http://docs.sublimetext.info/en/latest/extensibility/snippets.html#snippet-features)

Only a subset of the snippets functionality in Sublime is supported right now. Fields are supported but the `$0` field is not. Snippet variables, mirrored fiels, and placeholders are not supported. At some future point they may be.

## Demo

Download the project and run the application. Try typing "html" into the text field and press *tab*. The text "html" is replaced by the snippet:

```
<html>
<head>
  <title></title>
</head>
<body>

</body>
</html>
```

And the insertion point is moved to the title tag's content. Press *tab* again and the insertion point is moved to the body tag's content. Press *shift-tab* to move the insertion point back to the title tag.