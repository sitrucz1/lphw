option explicit

sub main()
    dim aat : set aat = new taat
    dim i, test : i = 0 : randomize timer : test = array(60,46,85,23,15,57,75,22,35,19,11)
    do while i <= ubound(test) and aat.isaat
        aat.aatputi(int(rnd*100) + 1)
        ' aat.aatputi(test(i))
        ' aat.levelorder
        i = i+1
    loop
    aat.levelorder
    wscript.echo aat.isaat
    aat.printtree
    wscript.stdout.write "Press RETURN to continue..."
    wscript.stdin.readline
    wscript.echo aat.aatfindi(aat.m_root.m_data).m_data
    wscript.echo aat.aatfindi(500).m_data
    wscript.stdout.write "Press RETURN to continue..."
    wscript.stdin.readline
    do until aat.isempty or not aat.isaat
        aat.aatdeletei(aat.m_root.m_data)
        ' aat.aatdeletei(22)
        aat.levelorder
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
    public m_qsize

    private sub class_initialize()
        set m_nil = new taatnode
        m_nil.m_data = 0
        m_nil.m_level = 0
        set m_nil.m_child(0) = m_nil
        set m_nil.m_child(1) = m_nil
        set m_root = m_nil
        m_cnt = 0
        m_qsize = 50
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
        dim node : set node = m_root
        do until node is m_nil
            if node.m_data = data then
                set aatfindi = node
                exit function
            end if
            dim way : way = node.m_data < data and 1
            set node = node.m_child(way)
        loop
        set aatfindi = node
    end function

    public function aatputi(byval data)
        wscript.echo "** Inserting => ", data
        dim node, na(50), wa(50), k ' stack
        k = 0 : set na(k) = makefakehead : wa(k) = 1 ' push fake head
        set node = m_root
        do until node is m_nil
            if node.m_data = data then
                set aatputi = node
                exit function
            end if
            k = k+1 : set na(k) = node : wa(k) = node.m_data < data and 1 ' push node
            set node = node.m_child(wa(k))
        loop
        ' create the new node
        set node = (new taatnode).init(data, m_nil)
        ' update parent link
        set na(k).m_child(wa(k)) = node
        ' fixup
        do until k < 1 or (na(k).m_level > na(k).m_child(0).m_level and na(k).m_level > na(k).m_child(1).m_level)
            set na(k) = aatskew(na(k))
            set na(k) = aatsplit(na(k))
            set na(k-1).m_child(wa(k-1)) = na(k)
            k = k-1
        loop
        ' update root
        set m_root = na(0).m_child(1)
        m_cnt = m_cnt+1
        set aatputi = node
    end function

    public function aatdeletei(byval data)
        wscript.echo "** Deleting => ", data
        dim node, na(50), wa(50), k, x ' stack
        x = 0 ' index of node on stack that is found
        k = 0 : set na(k) = makefakehead : wa(k) = 1 ' push fake root
        set node = m_root
        do until node is m_nil
            k = k+1 : set na(k) = node : wa(k) = node.m_data <= data and 1 ' push node
            if wa(k) = 1 then
                x = k ' mark the critical node
            end if
            set node = node.m_child(wa(k))
        loop
        ' x is the found node. k is the leaf with 0 or 1 children
        wscript.echo "x, k, xdata, kdata => ", x, k, na(x).m_data, na(k).m_data
        if x = 0 or na(x).m_data <> data then
            set aatdeletei = node   ' not found
            exit function
        end if
        set node = na(k) ' save pointer to deleted node
        ' splice out the node
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

    public sub levelorder()
        dim qq(), qh, qt, qc : redim qq(m_qsize-1) : qh = 0 : qt = 0 : qc = 0 ' queue variables
        if m_root is m_nil then
            exit sub
        end if
        set qq(qh) = m_root : qh = (qh+1) mod m_qsize : qc = qc+1 ' enqueue root
        do until qc = 0 ' queue empty
            dim node : set node = qq(qt) : qt = (qt+1) mod m_qsize : qc = qc-1 ' dequeue
            wscript.stdout.write node.m_data & "," & node.m_level & " "
            if not node.m_child(0) is m_nil then
                set qq(qh) = node.m_child(0) : qh = (qh+1) mod m_qsize : qc = qc+1 ' enqueue left
            end if
            if not node.m_child(1) is m_nil then
                set qq(qh) = node.m_child(1) : qh = (qh+1) mod m_qsize : qc = qc+1 ' enqueue right
            end if
        loop
        wscript.stdout.writeline
    end sub

    public sub printtree()
        dim qq(), qh, qt, qc : redim qq(m_qsize-1) : qh = 0 : qt = 0 : qc = 0 ' queue variables
        if m_root is m_nil then
            exit sub
        end if
        set qq(qh) = m_root : qh = (qh+1) mod m_qsize : qc = qc+1 ' enqueue root
        dim lcnt : lcnt = qc
        do until qc = 0 ' queue empty
            do until lcnt = 0
                dim node : set node = qq(qt) : qt = (qt+1) mod m_qsize : qc = qc-1 ' dequeue
                ' print the node and it's pseudo node if at the same level
                dim rc : set rc = node.m_child(1)
                wscript.stdout.write node.m_data
                if node.m_level = rc.m_level then
                    wscript.stdout.write "," & rc.m_data
                end if
                wscript.stdout.write "  "
                if not node.m_child(0) is m_nil then
                    set qq(qh) = node.m_child(0) : qh = (qh+1) mod m_qsize : qc = qc+1 ' enqueue left
                end if
                if node.m_level = rc.m_level then ' process the pseudo node as well
                    if not rc.m_child(0) is m_nil then
                        set qq(qh) = rc.m_child(0) : qh = (qh+1) mod m_qsize : qc = qc+1 ' enqueue pseudo left
                    end if
                    if not rc.m_child(1) is m_nil and rc.m_level <> rc.m_child(1).m_level then
                        set qq(qh) = rc.m_child(1) : qh = (qh+1) mod m_qsize : qc = qc+1 ' enqueue pseudo right
                    end if
                else ' not a pseudo node
                    if not node.m_child(1) is m_nil then
                        set qq(qh) = node.m_child(1) : qh = (qh+1) mod m_qsize : qc = qc+1 ' enqueue right
                    end if
                end if
                lcnt = lcnt-1
            loop
            wscript.stdout.writeline
            lcnt = qc ' set level count to next level size
        loop
        wscript.stdout.writeline
    end sub

end class

call main()
