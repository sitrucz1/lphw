'
' AVL Tree
'

option explicit

sub main()
    dim avlitem : set avlitem = (new tavlitem).init(5)

    dim avltree : set avltree = new tavltree
    avltree.put((new tavlitem).init(15))
    avltree.put((new tavlitem).init(10))
    avltree.put((new tavlitem).init(7))
    avltree.print
end sub

class tavlitem

    public m_item
    public m_bal
    public m_left
    public m_right

    public function init(item)
        if vartype(item) = vbobject then
            set m_item = item
        else
            m_item = item
        end if
        m_bal = 0
        set m_left = nothing
        set m_right = nothing
        set init = me
    end function

end class

class tavltree

    public m_root
    public m_cnt

    private sub class_initialize()
        set m_root = nothing
        m_cnt = 0
    end sub

    public function put(byval item)
        dim done : done = false
        set m_root = putitem(m_root, item, done)
    end function

    private function putitem(byval node, byval item, byref done)
        if node is nothing then
            set putitem = item
        elseif item.m_item = node.m_item then
            set putitem = node
        else
            if item.m_item < node.m_item then
                set node.m_left = putitem(node.m_left, item)
                ' node.m_bal = node.m_left.m_bal-1
                ' if node.m_bal < -1 and node.m_right.m_bal = 1 then
                '     set node.m_left = rotateleft(node.m_left)
                '     set node = rotateright(node)
                ' elseif node.m_bal < -1 and node.m_right.m_bal = -1 then
                '     set node = rotateright(node)
                ' end if
            else
                set node.m_right = putitem(node.m_right, item)
                ' node.m_bal = node.m_right.m_bal+1
                ' if node.m_bal > 1 and node.m_right.m_bal = -1 then
                '     set node.m_right = rotateright(node.m_right)
                '     set node = rotateleft(node)
                ' elseif node.m_bal > 1 and node.m_right.m_bal = 1 then
                '     set node = rotateleft(node)
                ' end if
            end if
            set putitem = node
        end if
    end function

    private function rotateleft(byval node)
        dim temp
        set temp = node.m_right
        set node.m_right = temp.m_left
        set temp.m_left = node
        set rotateleft = temp
    end function

    private function rotateright(byval node)
        dim temp
        set temp = node.m_left
        set node.m_left = temp.m_right
        set temp.m_right = node
        set rotateright = temp
    end function

    public sub print()
        printitem m_root
    end sub

    private sub printitem(byval node)
        if node is nothing then
            ' wscript.stdout.write "*,0 "
        else
            wscript.stdout.writeline formatnode(node)
            printitem(node.m_left)
            printitem(node.m_right)
        end if
    end sub

    private function formatnode(byval node)
        if node is nothing then
            formatnode = ""
        else
            if node.m_left is nothing then
                formatnode = "*,0 "
            else
                formatnode = node.m_left.m_item & "," & node.m_left.m_bal & " "
            end if
            formatnode = formatnode & node.m_item & "," & node.m_bal & " "
            if node.m_right is nothing then
                formatnode = formatnode & "*,0 "
            else
                formatnode = formatnode & node.m_right.m_item & "," & node.m_right.m_bal & " "
            end if
        end if
    end function

end class

call main()
