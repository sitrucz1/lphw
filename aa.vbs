option explicit

sub main()
    includefile "queue.vbs"     ' tqueue and tstack
end sub

sub includefile(fspec)
    executeglobal createobject("scripting.filesystemobject").opentextfile(fspec).readall()
end sub

class taatnode

    public m_data
    public m_child(1)
    public m_level

    public function init(byval data)
        m_data = data
        set m_child(0) = nothing
        set m_child(1) = nothing
        m_level = 1
        set init = me
    end function

end class

class taat

    public m_root
    public m_cnt

    private sub class_initialize()
        set m_root = nothing
        m_cnt = 0
    end sub

    private function isless(a, b)
        if a is nothing or b is nothing then
            isless = false
        else
            isless = (a.m_data < b.m_data)
        end if
    end function

    private function max(a, b)
        if a > b then
            max = a
        else
            max = b
        end if
    end function

    public function getlevel(byval node)
        if node is nothing then
            getlevel = 0
        else
            getlevel = node.m_level
        end if
    end function

    public function isaat
        isaat = isaatnode(m_root, 0) <> -1
    end function

    public function isaatnode(byval node, byval plevel)
        if node is nothing then
            isaatnode = 0
        elseif isless(node, node.m_child(0)) or isless(node.m_child(1), node) then
            wscript.echo "ERROR: not a bst"
            isaatnode = -1
        elseif node.m_level < 1 then
            wscript.echo "ERROR: node level should be greater than zero.", node.m_data
            isaatnode = -1
        else
            dim lc, rc, grc
            lc = getlevel(node.m_child(0))
            rc = getlevel(node.m_child(1))
            if rc > 0 then
                grc = getlevel(node.m_child(1).m_child(1))
            else
                grc = 0
            end if
            if node.m_level <> lc+1 then
                wscript.echo "ERROR: left child level is not one less than parent.", node.m_data
                isaatnode = -1
            elseif node.m_level <> rc and node.m_level <> rc+1 then
                wscript.echo "ERROR: right child level is not equal or one less than parent.", node.m_data
                isaatnode = -1
            elseif node.m_level = rc and node.m_level = grc then
                wscript.echo "ERROR: right grandchild level is equal to grandparent.", node.m_data
                isaatnode = -1
            else
                dim lh, rh ' level counts
                lh = isaatnode(node.m_child(0), node.m_level)
                rh = isaatnode(node.m_child(1), node.m_level)
                if lh = -1 or rh = -1 then
                   isaatnode = -1
                elseif node.m_level <> plevel then
                    isaatnode = lh+1
                else
                    isaatnode = lh
                end if
            end if
        end if
    end function

    public function rotate(byval node, byval way)
        dim root : set root = node.m_child(way xor 1)
        set node.m_child(way xor 1) = root.m_child(way)
        set root.m_child(way) = node
        set rotate = root
    end function

    public function aatfindi(data)
        dim node : set node = m_root
        do until node is nothing
            if node.m_data = data then
                exit do
            end if
            dim way : way = (node.m_data < data) and 1
            set node = node.m_child(way)
        loop
        set aatfindi = node
    end function

    public function aatputi(byval data)
        dim node, parent, way : set node = m_root : set parent = nothing
        do until node is nothing
            if node.m_data = data then
                set aatputi = node
                exit function
            end if
            set parent = node
            way = (node.m_data < data) and 1
            set node = node.m_child(way)
        loop
        set node = (new taatnode).init(data)
        if parent is nothing then
            set m_root = node
        else
            set parent.m_child(way) = node
        end if
        set aatputi = node
    end function

    public function aatdeletei(byval data)
        dim node, parent, q, way : set node = m_root : set parent = nothing
        do until node is nothing
            if node.m_data = data then
                exit do
            end if
            set parent = node
            way = (node.m_data < data) and 1
            set node = node.m_child(way)
        loop
        if node is nothing then ' not found
            set aatdeletei = node
            exit function
        end if
        if node.m_child(0) is nothing then
            set q = node.m_child(1)
        elseif node.m_child(1) is nothing then
            set q = node.m_child(0)
        else
            set parent = node
            way = 1 ' right child
            dim succ : set succ = node.m_child(1)
            do until succ.m_child(0) is nothing
                set parent = succ
                way = 0
                set succ = succ.m_next(0)
            loop
            node.m_data = succ.m_data
            set q = succ.m_child(1)
        end if
        if parent is nothing then
            set m_root = q
        else
            set parent.m_child(way) = q
        end if
        set aatdeletei = node
    end function

    public sub preorderi()
        dim stack : set stack = new tstack
        dim node : set node = m_root
        do until node is nothing and stack.isempty
            if not node is nothing then
                wscript.stdout.write node.m_data & " "
                stack.push node
                set node = node.m_child(0)  ' left child
            else
                set node = stack.pop
                set node = node.m_child(1)  ' right child
            end if
        loop
        wscript.stdout.writeline
    end sub

    public sub inorderi()
        dim stack : set stack = new tstack
        dim node : set node = m_root
        do until node is nothing and stack.isempty
            if not node is nothing then
                stack.push node
                set node = node.m_child(0)  ' left child
            else
                set node = stack.pop
                wscript.stdout.write node.m_data & " "
                set node = node.m_child(1)  ' right child
            end if
        loop
        wscript.stdout.writeline
    end sub

    public sub postorderi()
        dim stack : set stack = new tstack
        dim node, prev : set node = m_root : set prev = nothing
        do until node is nothing and stack.isempty
            if not node is nothing then
                stack.push node
                set node = node.m_child(0)  ' left child
            else
                set node = stack.pop
                if node.m_child(1) is nothing or node.m_child(1) is prev then
                    wscript.stdout.write node.m_data & " "
                    set prev = node
                    set node = nothing
                else
                    stack.push node
                    set node = node.m_child(1)  ' right child
                end if
            end if
        loop
        wscript.stdout.writeline
    end sub

    public sub levelorderi()
        dim queue : set queue = new tqueue
        if m_root is nothing then
            exit sub
        end if
        queue.enqueue m_root
        do until queue.isempty
            dim node : set node = queue.dequeue
            wscript.stdout.write node.m_data & " "
            if not node.m_child(0) is nothing then
                queue.enqueue node.m_child(0)
            end if
            if not node.m_child(1) is nothing then
                queue.enqueue node.m_child(1)
            end if
        loop
        wscript.stdout.writeline
    end sub

    public function heighti()
        dim stack : set stack = new tstack
        dim node, prev : set node = m_root : set prev = nothing
        dim hcnt, hmax : hcnt = 0 : hmax = 0
        do until node is nothing and stack.isempty
            if not node is nothing then
                stack.push node
                hcnt = hcnt+1
                set node = node.m_child(0)  ' left child
            else
                set node = stack.pop
                if node.m_child(1) is nothing or node.m_child(1) is prev then
                    if hcnt > hmax then
                        hmax = hcnt
                    end if
                    hcnt = hcnt-1
                    set prev = node
                    set node = nothing
                else
                    stack.push node
                    set node = node.m_child(1)  ' right child
                end if
            end if
        loop
        heighti = hmax
    end function

    public function heightiq()
        dim queue : set queue = new tqueue
        if m_root is nothing then
            heightiq = 0
            exit function
        end if
        queue.enqueue m_root
        dim hcnt, lcnt : hcnt = 0 : lcnt = queue.length
        do until queue.isempty
            dim node : set node = queue.dequeue
            if not node.m_child(0) is nothing then
                queue.enqueue node.m_child(0)   ' left child
            end if
            if not node.m_child(1) is nothing then
                queue.enqueue node.m_child(1)   ' right child
            end if
            lcnt = lcnt-1
            if lcnt = 0 then        ' all done with current level
                hcnt = hcnt+1
                lcnt = queue.length ' set level count to next level size
            end if
        loop
        heightiq = hcnt
    end function

end class

call main()
