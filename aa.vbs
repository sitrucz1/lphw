option explicit

sub main()
    includefile "queue.vbs"     ' tqueue and tstack
    dim aat : set aat = new taat
    dim i, test : i = 0 : randomize timer : test = array(60,46,85,23,15)
    do while i <= ubound(test) and aat.isaat
        aat.aatputi(int(rnd*100) + 1)
        ' aat.aatputi(test(i))
        ' aat.levelorderi
        i = i+1
    loop
    wscript.echo aat.aatfindi(aat.m_root.m_data)
    wscript.echo aat.aatfindi(500)
    do until aat.isempty or not aat.isaat
        aat.aatdeletei(aat.m_root.m_data)
        ' aat.aatdeletei(22)
        ' aat.levelorderi
    loop
end sub

sub includefile(fspec)
    executeglobal createobject("scripting.filesystemobject").opentextfile(fspec).readall()
end sub

class taatnode

    public m_data
    public m_level
    public m_child(1)

    public function init(byval data, byval nilnode)
        m_data = data
        m_level = 1
        set m_child(0) = nilnode
        set m_child(1) = nilnode
        set init = me
    end function

end class

class taat

    public m_root
    public m_nil
    public m_cnt

    private sub class_initialize()
        set m_nil = new taatnode
        m_nil.m_data = 0
        m_nil.m_level = 0
        set m_nil.m_child(0) = m_nil
        set m_nil.m_child(1) = m_nil
        set m_root = m_nil
        m_cnt = 0
    end sub

    private function isless(a, b)
        if a is m_nil or b is m_nil then
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
        getlevel = node.m_level
    end function

    public function isempty
        isempty = m_root is m_nil
    end function

    public function isaat
        isaat = isaatnode(m_root, 0) <> -1
    end function

    public function isaatnode(byval node, byval plevel)
        if node is m_nil then
            isaatnode = 0
        elseif m_nil.m_level <> 0 then
            wscript.echo "ERROR: sentinel level is not 0."
            isaatnode = -1
        elseif not m_nil.m_child(0) is m_nil or not m_nil.m_child(1) is m_nil then
            wscript.echo "ERROR: sentinel children don't point to itself."
            isaatnode = -1
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
            grc = getlevel(node.m_child(1).m_child(1))
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
                elseif lh <> rh then
                    wscript.echo "ERROR: heights don't match.", node.m_data, lh, rh
                    isaatnode = -1
                elseif node.m_level <> plevel then
                    isaatnode = lh+1
                else
                    isaatnode = lh
                end if
            end if
        end if
    end function

    public function makefakehead
        dim node
        set node = (new taatnode).init(0, m_nil)
        node.m_level = 0
        set node.m_child(1) = m_root
        set makefakehead = node
    end function

    public function aatskew(byval node)
        if getlevel(node) = getlevel(node.m_child(0)) then
            wscript.echo "Case 1 - Skew node.", node.m_data
            dim temp
            set temp = node
            set node = temp.m_child(0)
            set temp.m_child(0) = node.m_child(1)
            set node.m_child(1) = temp
        end if
        set aatskew = node
    end function

    public function aatsplit(byval node)
        if getlevel(node) = getlevel(node.m_child(1).m_child(1)) then
            wscript.echo "Case 2 - Split node.", node.m_data
            dim temp
            set temp = node
            set node = temp.m_child(1)
            set temp.m_child(1) = node.m_child(0)
            set node.m_child(0) = temp
            node.m_level = node.m_level+1
        end if
        set aatsplit = node
    end function

    public function aatfindi(data)
        dim node
        m_nil.m_data = data
        set node = m_root
        do until node.m_data = data
            dim way : way = (node.m_data <= data) and 1
            set node = node.m_child(way)
        loop
        m_nil.m_data = 0
        aatfindi = not node is m_nil
    end function

    public function aatputi(byval data)
        wscript.echo "** Inserting => ", data
        dim node, na(50), wa(50), k
        k = 0
        set na(k) = makefakehead
        wa(k) = 1
        set node = m_root
        do until node is m_nil
            k = k+1
            set na(k) = node
            wa(k) = (node.m_data < data) and 1
            if node.m_data = data then
                set aatputi = node
                exit function
            end if
            set node = node.m_child(wa(k))
        loop
        ' create the new node
        set node = (new taatnode).init(data, m_nil)
        ' update parent link
        set na(k).m_child(wa(k)) = node
        ' fixup
        for k = k to 1 step -1
            set na(k) = aatskew(na(k))
            set na(k) = aatsplit(na(k))
            set na(k-1).m_child(wa(k-1)) = na(k)
        next
        ' update root
        set m_root = na(0).m_child(1)
        m_cnt = m_cnt+1
        set aatputi = node
    end function

    public function aatdeletei(byval data)
        wscript.echo "** Deleting => ", data
        dim node, na(50), wa(50), k, x
        x = 0
        k = 0
        set na(k) = makefakehead
        wa(k) = 1 ' fake root right child is real root
        set node = m_root
        do until node is m_nil
            k = k+1
            set na(k) = node
            wa(k) = (node.m_data <= data) and 1
            if wa(k) = 1 then
                x = k
            end if
            set node = node.m_child(wa(k))
        loop
        ' x is the found node. k is the leaf with 0 or 1 children
        wscript.echo "x, k, xdata, kdata => ", x, k, na(x).m_data, na(k).m_data
        if x = 0 or na(x).m_data <> data then
            set aatdeletei = node   ' not found
            exit function
        end if
        ' splice out the node
        set node = na(k)
        na(x).m_data = na(k).m_data
        set na(k-1).m_child(wa(k-1)) = na(k).m_child(wa(k) xor 1)
        ' fixup
        for k = k-1 to 1 step -1
            wscript.echo "Checking k, kdata => ", k, na(k).m_data
            if na(k).m_child(0).m_level < na(k).m_level-1 or na(k).m_child(1).m_level < na(k).m_level-1 then
                wscript.echo "Fixup k, kdata => ", k, na(k).m_data
                na(k).m_level = na(k).m_level-1
                if na(k).m_child(1).m_level > na(k).m_level then
                    na(k).m_child(1).m_level = na(k).m_level
                end if
                set na(k) = aatskew(na(k))
                set na(k).m_child(1) = aatskew(na(k).m_child(1))
                set na(k).m_child(1).m_child(1) = aatskew(na(k).m_child(1).m_child(1))
                set na(k) = aatsplit(na(k))
                set na(k).m_child(1) = aatsplit(na(k).m_child(1))
                set na(k-1).m_child(wa(k-1)) = na(k)
            end if
        next
        ' update the root and counts
        set m_root = na(0).m_child(1)
        m_cnt = m_cnt-1
        set aatdeletei = node
    end function

    public sub preorderi()
        dim stack : set stack = new tstack
        dim node : set node = m_root
        do until node is m_nil and stack.isempty
            if not node is m_nil then
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
        do until node is m_nil and stack.isempty
            if not node is m_nil then
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
        dim node, prev : set node = m_root : set prev = m_nil
        do until node is m_nil and stack.isempty
            if not node is m_nil then
                stack.push node
                set node = node.m_child(0)  ' left child
            else
                set node = stack.pop
                if node.m_child(1) is m_nil or node.m_child(1) is prev then
                    wscript.stdout.write node.m_data & " "
                    set prev = node
                    set node = m_nil
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
        if m_root is m_nil then
            exit sub
        end if
        queue.enqueue m_root
        do until queue.isempty
            dim node : set node = queue.dequeue
            wscript.stdout.write node.m_data & "," & node.m_level & " "
            if not node.m_child(0) is m_nil then
                queue.enqueue node.m_child(0)
            end if
            if not node.m_child(1) is m_nil then
                queue.enqueue node.m_child(1)
            end if
        loop
        wscript.stdout.writeline
    end sub

    public function heighti()
        dim stack : set stack = new tstack
        dim node, prev : set node = m_root : set prev = m_nil
        dim hcnt, hmax : hcnt = 0 : hmax = 0
        do until node is m_nil and stack.isempty
            if not node is m_nil then
                stack.push node
                hcnt = hcnt+1
                set node = node.m_child(0)  ' left child
            else
                set node = stack.pop
                if node.m_child(1) is m_nil or node.m_child(1) is prev then
                    if hcnt > hmax then
                        hmax = hcnt
                    end if
                    hcnt = hcnt-1
                    set prev = node
                    set node = m_nil
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
        if m_root is m_nil then
            heightiq = 0
            exit function
        end if
        queue.enqueue m_root
        dim hcnt, lcnt : hcnt = 0 : lcnt = queue.length
        do until queue.isempty
            dim node : set node = queue.dequeue
            if not node.m_child(0) is m_nil then
                queue.enqueue node.m_child(0)   ' left child
            end if
            if not node.m_child(1) is m_nil then
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
