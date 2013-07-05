/**
 * Using sax-reader to read complex XML files
 * Each temp-table corresponds to a xml node
 */

def temp-table tt_ide no-undo
    field cUF  as char
    field cNF  as char.

def temp-table tt_emit no-undo
    field cnpj  as char format "x(20)"
    field xNome as char format "x(30)".

def var h-sax  as handle no-undo.
def var h-tt   as handle no-undo. /* handle to the current temp-table (parent node) */
def var c-node as char   no-undo. /* current child node (temp-table field) */


/* Main Block */
create sax-reader h-sax.
h-sax:handler = this-procedure.
h-sax:set-input-source("file", "xml_teste.xml"). /* file must be in the current working directory */
h-sax:sax-parse().

for each tt_ide:
    disp tt_ide with title "IDE".
end.

for each tt_emit:
    disp tt_emit with title "EMIT".
end.


/* SAX-READER Callbacks */
procedure characters:
    def input parameter charData as longchar no-undo.
    def input parameter numChars as int      no-undo.

    if not valid-handle(h-tt) then return.

    h-tt:buffer-field(c-node):buffer-value = charData no-error.
end.

procedure StartElement:
    def input param namespaceURI as char   no-undo.
    def input param localName    as char   no-undo.
    def input param qName        as char   no-undo.
    def input param attributes   as handle no-undo.

    case qName:
        when "ide" then do:
            create tt_ide.
            h-tt = buffer tt_ide:handle.
        end.
        when "emit" then do:
            create tt_emit.
            h-tt = buffer tt_emit:handle.
        end.
        otherwise do:
            assign c-node = qName.
        end.
    end case.

end.

procedure EndElement:
    def input param namespaceuri as char no-undo.
    def input param localname    as char no-undo.
    def input param qname        as char no-undo.

    if qName = "emit" then
        self:stop-parsing.
end.
