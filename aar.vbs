option explicit

const QSIZE = 50

sub main()
    includefile "queue.vbs"     ' tqueue and tstack
    dim aat : set aat = new taat
    dim i, test : i = 0 : randomize timer : test = array(60,22,37,46,85,23,15,57,75,22,35,19,11)
    ' inserting data
    do while i <= ubound(test) and aat.isaat and aat.sizevalid
    ' do while i <= 16 and aat.isaat and aat.rankvalid
        ' aat.aatput(int(rnd*100) + 1)
        aat.aatput(test(i))
        aat.levelorder
        i = i+1
    loop
    aat.levelorder
    wscript.echo aat.isaat
    wscript.echo "** Height, level, count, log2n, 2log2n => ", aat.height, aat.m_root.m_level, aat.m_cnt, int(log(aat.m_cnt) / log(2)), 2*int(log(aat.m_cnt) / log(2))
    aat.printtree
    wscript.echo aat.inorder
    wscript.echo aat.getfloor(43).m_data
    wscript.echo aat.getmin.m_data
    wscript.echo aat.getmax.m_data
    wscript.echo aat.getindexof(-1).m_data
    wscript.echo aat.getindexof(0).m_data
    wscript.echo aat.getindexof(5).m_data
    wscript.echo aat.getindexof(3).m_data
    wscript.echo aat.getindex(22)
    wscript.echo aat.getindex(85)
    wscript.echo aat.getindex(35)
    wscript.echo aat.getindex(105)
    wscript.echo aat.getindex(11)
    wscript.stdout.write "Press return key to continue..." : wscript.stdin.readline
    ' finding data
    wscript.echo aat.aatfind(aat.m_root.m_data).m_data
    wscript.echo aat.aatfind(500).m_data
    wscript.stdout.write "Press return key to continue..." : wscript.stdin.readline
    ' deleting data
    ' do until aat.isempty or not aat.isaat or not aat.sizevalid
        ' aat.aatdelete(aat.m_root.m_data)
        ' aat.aatdeletemin
        aat.aatdelete(22)
        ' aat.levelorder
        aat.printtree
    ' loop
end sub

sub includefile(fspec)
    executeglobal createobject("scripting.filesystemobject").opentextfile(fspec).readall()
end sub

class taatnode

    public m_data
    public m_level
    public m_child(1)
    public m_size

    public function init(byval data, byval nilnode)
        m_data = data
        m_level = 1
        set m_child(0) = nilnode
        set m_child(1) = nilnode
        m_size = 1
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
            elseif node.m_level = grc then
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

    public function sizevalid()
        sizevalid = (sizevalidn(m_root) <> -1)
    end function

    public function sizevalidn(byval node)
        if node is m_nil then
            sizevalidn = 0
        else
            dim lc, rc, t
            lc = sizevalidn(node.m_child(0))
            rc = sizevalidn(node.m_child(1))
            t = 1+lc+rc
            ' wscript.echo "key, m_size, size => ", node.m_data, node.m_size, t
            if lc = -1 or rc = -1 then
                sizevalidn = -1
            elseif t <> node.m_size then
                sizevalidn = -1
            else
                sizevalidn = t
            end if
        end if
    end function

    public function getfloor(byval key)
        wscript.echo "Getfloor => ", key
        set getfloor = getfloorn(m_root, key)
    end function

    public function getfloorn(byval node, byval key)
        if node is m_nil then
            set getfloorn = m_nil
        elseif key = node.m_data then
            set getfloorn = node
        elseif key < node.m_data then
            set getfloorn = getfloorn(node.m_child(0), key)
        else
            dim t : set t = getfloorn(node.m_child(1), key)
            if t is m_nil then
                set getfloorn = node
            else
                set getfloorn = t
            end if
        end if
    end function

    public function getceiling(byval key)
        wscript.echo "Getceiling => ", key
        set getceiling = getceilingn(m_root, key)
    end function

    public function getceilingn(byval node, byval key)
        if node is m_nil then
            set getceilingn = m_nil
        elseif key = node.m_data then
            set getceilingn = node
        elseif key > node.m_data then
            set getceilingn = getceilingn(node.m_child(1), key)
        else
            dim t : set t = getceilingn(node.m_child(0), key)
            if t is m_nil then
                set getceilingn = node
            else
                set getceilingn = t
            end if
        end if
    end function

    public function getmin()
        wscript.echo "Getmin"
        set getmin = getminn(m_root)
    end function

    public function getminn(byval node)
        if node is m_nil then
            set getminn = m_nil
        elseif node.m_child(0) is m_nil then
            set getminn = node
        else
            set getminn = getminn(node.m_child(0))
        end if
    end function
            
    public function getmax()
        wscript.echo "Getmax"
        set getmax = getmaxn(m_root)
    end function

    public function getmaxn(byval node)
        if node is m_nil then
            set getmaxn = m_nil
        elseif node.m_child(1) is m_nil then
            set getmaxn = node
        else
            set getmaxn = getmaxn(node.m_child(1))
        end if
    end function
            
    public function getindex(byval key)
        wscript.echo "Getindex => ", key
        getindex = getindexn(m_root, key, 0)
    end function

    public function getindexn(byval node, byval key, byval index)
        if node is m_nil then
            getindexn = -1
        elseif key = node.m_data then
            getindexn = aasize(node.m_child(0)) + index
        elseif key < node.m_data then
            getindexn = getindexn(node.m_child(0), key, index)
        else
            getindexn = getindexn(node.m_child(1), key, 1 + aasize(node.m_child(0)) + index)
        end if
    end function

    public function getindexof(byval index)
        wscript.echo "Getindexof => ", index
        if index < -1 or index > m_cnt-1 then
            set getindexof = m_nil
        elseif index = -1 then
            set getindexof = getindexofn(m_root, m_cnt-1)
        else
            set getindexof = getindexofn(m_root, index)
        end if
    end function

    public function getindexofn(byval node, byval index)
        if node is m_nil then
            set getindexofn = m_nil
        else
            dim t : t = aasize(node.m_child(0))
            ' wscript.echo "key, index, t => ", node.m_data, index, t
            if index < t then
                set getindexofn = getindexofn(node.m_child(0), index)
            elseif index > t then
                set getindexofn = getindexofn(node.m_child(1), index-t-1)
            else
                set getindexofn = node
            end if
        end if
    end function

    public sub aasetsize(byval node)
        if not node is m_nil then
            node.m_size = 1 + aasize(node.m_child(0)) + aasize(node.m_child(1))
        end if
    end sub

    public function aasize(byval node)
        if node is m_nil then
            aasize = 0
        else
            aasize = node.m_size
        end if
    end function

    public function aatskew(byval node)
        if not node is m_nil and getlevel(node) = getlevel(node.m_child(0)) then
            wscript.echo "Case 1 - Skew node.", node.m_data
            dim temp
            set temp = node
            set node = temp.m_child(0)
            set temp.m_child(0) = node.m_child(1)
            set node.m_child(1) = temp
            aasetsize temp
            aasetsize node
        end if
        set aatskew = node
    end function

    public function aatsplit(byval node)
        if not node is m_nil and getlevel(node) = getlevel(node.m_child(1).m_child(1)) then
            wscript.echo "Case 2 - Split node.", node.m_data
            dim temp
            set temp = node
            set node = temp.m_child(1)
            set temp.m_child(1) = node.m_child(0)
            set node.m_child(0) = temp
            node.m_level = node.m_level+1
            aasetsize temp
            aasetsize node
        end if
        set aatsplit = node
    end function

    public function aatfind(byval data)
        wscript.echo "** Finding => ", data
        set aatfind = aatfindnode(m_root, data)
    end function

    private function aatfindnode(byval node, byval data)
        if node is m_nil then
            set node = m_nil
        elseif node.m_data = data then
            node.m_data = data
        else
            dim way : way = node.m_data < data and 1
            set node = aatfindnode(node.m_child(way), data)
        end if
        set aatfindnode = node
    end function

    public function aatput(byval data)
        wscript.echo "** Inserting => ", data
        set m_root = aatputnode(m_root, data)
        set aatput = m_root
    end function

    private function aatputnode(byval node, byval data)
        if node is m_nil then
            set node = (new taatnode).init(data, m_nil)
            m_cnt = m_cnt+1
        elseif node.m_data = data then
            node.m_data = data
        else
            dim way : way = node.m_data < data and 1
            set node.m_child(way) = aatputnode(node.m_child(way), data)
        end if
        ' fixup
        set node = aatskew(node)
        set node = aatsplit(node)
        aasetsize node
        set aatputnode = node
    end function

    public function aatbalance(byval node)
        if node.m_child(0).m_level < node.m_level-1 or node.m_child(1).m_level < node.m_level-1 then
            node.m_level = node.m_level-1
            if node.m_child(1).m_level > node.m_level then
                node.m_child(1).m_level = node.m_level
            end if
            set node = aatskew(node)
            set node.m_child(1) = aatskew(node.m_child(1))
            set node.m_child(1).m_child(1) = aatskew(node.m_child(1).m_child(1))
            set node = aatsplit(node)
            set node.m_child(1) = aatsplit(node.m_child(1))
        end if
        aasetsize node
        set aatbalance = node
    end function

    public function aatdeletemin()
        wscript.echo "** Deleting min."
        set m_root = aatdeleteminn(m_root)
        set aatdeletemin = m_nil
    end function

    public function aatdeleteminn(byval node)
        if node.m_child(0) is m_nil then
            set aatdeleteminn = node.m_child(1)
            exit function
        end if
        set node.m_child(0) = aatdeleteminn(node.m_child(0))
        set aatdeleteminn = aatbalance(node)
    end function

    public function aatdeletemax()
        wscript.echo "** Deleting max."
        set m_root = aatdeletemaxn(m_root)
        set aatdeletemax = m_nil
    end function

    public function aatdeletemaxn(byval node)
        if node.m_child(1) is m_nil then
            set aatdeletemaxn = node.m_child(0)
            exit function
        end if
        set node.m_child(1) = aatdeletemaxn(node.m_child(1))
        set aatdeletemaxn = aatbalance(node)
    end function

    public function aatdelete(byval data)
        wscript.echo "** Deleting => ", data
        set m_root = aatdeletenode(m_root, data)
        set aatdelete = m_root
    end function

    private function aatdeletenode(byval node, byval data)
        if node is m_nil then
            set aatdeletenode = m_nil
            exit function
        elseif node.m_data <> data then
            dim way : way = node.m_data < data and 1
            set node.m_child(way) = aatdeletenode(node.m_child(way), data)
        else ' found it
            if not node.m_child(0) is m_nil and not node.m_child(1) is m_nil then
                ' two children find inorder successor
                dim x : set x = getminn(node.m_child(1))
                node.m_data = x.m_data
                set node.m_child(1) = aatdeletenode(node.m_child(1), x.m_data)
            else ' one child or leaf node delete it
                if node.m_child(0) is m_nil then
                    set node = node.m_child(1)
                else
                    set node = node.m_child(0)
                end if
                m_cnt = m_cnt-1
            end if
        end if
        set aatdeletenode = aatbalance(node)
    end function

    public sub preorder
        preordernode m_root
        wscript.stdout.writeline
    end sub

    private sub preordernode(byval node)
        if not node is m_nil then
            wscript.stdout.write node.m_data & " "
            preordernode node.m_child(0)
            preordernode node.m_child(1)
        end if
    end sub

    public sub inorder
        inordernode m_root
        wscript.stdout.writeline
    end sub

    private sub inordernode(byval node)
        if not node is m_nil then
            inordernode node.m_child(0)
            wscript.stdout.write node.m_data & " "
            inordernode node.m_child(1)
        end if
    end sub

    public sub postorder
        postordernode m_root
        wscript.stdout.writeline
    end sub

    private sub postordernode(byval node)
        if not node is m_nil then
            postordernode node.m_child(0)
            postordernode node.m_child(1)
            wscript.stdout.write node.m_data & " "
        end if
    end sub

    public sub levelorder()
        dim qq(), qh, qt, qc : redim qq(QSIZE-1) : qh = 0 : qt = 0 : qc = 0 ' queue variables
        if m_root is m_nil then
            exit sub
        end if
        set qq(qh) = m_root : qh = (qh+1) mod QSIZE : qc = qc+1 ' enqueue root
        do until qc = 0 ' queue empty
            dim node : set node = qq(qt) : qt = (qt+1) mod QSIZE : qc = qc-1 ' dequeue
            wscript.stdout.write node.m_data & "," & node.m_level & " "
            if not node.m_child(0) is m_nil then
                set qq(qh) = node.m_child(0) : qh = (qh+1) mod QSIZE : qc = qc+1 ' enqueue left
            end if
            if not node.m_child(1) is m_nil then
                set qq(qh) = node.m_child(1) : qh = (qh+1) mod QSIZE : qc = qc+1 ' enqueue right
            end if
        loop
        wscript.stdout.writeline
    end sub

    public sub printtree()
        dim qq(), qh, qt, qc : redim qq(QSIZE-1) : qh = 0 : qt = 0 : qc = 0 ' queue variables
        if m_root is m_nil then
            exit sub
        end if
        set qq(qh) = m_root : qh = (qh+1) mod QSIZE : qc = qc+1 ' enqueue root
        dim lcnt : lcnt = qc
        do until qc = 0 ' queue empty
            do until lcnt = 0
                dim node : set node = qq(qt) : qt = (qt+1) mod QSIZE : qc = qc-1 ' dequeue
                ' print the node and it's pseudo node if at the same level
                dim rc : set rc = node.m_child(1)
                wscript.stdout.write node.m_data
                if node.m_level = rc.m_level then
                    wscript.stdout.write "," & rc.m_data
                end if
                wscript.stdout.write "  "
                if not node.m_child(0) is m_nil then
                    set qq(qh) = node.m_child(0) : qh = (qh+1) mod QSIZE : qc = qc+1 ' enqueue left
                end if
                if node.m_level = rc.m_level then ' process the pseudo node as well
                    if not rc.m_child(0) is m_nil then
                        set qq(qh) = rc.m_child(0) : qh = (qh+1) mod QSIZE : qc = qc+1 ' enqueue pseudo left
                    end if
                    if not rc.m_child(1) is m_nil and rc.m_level <> rc.m_child(1).m_level then
                        set qq(qh) = rc.m_child(1) : qh = (qh+1) mod QSIZE : qc = qc+1 ' enqueue pseudo right
                    end if
                else ' not a pseudo node
                    if not node.m_child(1) is m_nil then
                        set qq(qh) = node.m_child(1) : qh = (qh+1) mod QSIZE : qc = qc+1 ' enqueue right
                    end if
                end if
                lcnt = lcnt-1
            loop
            wscript.stdout.writeline
            lcnt = qc ' set level count to next level size
        loop
        wscript.stdout.writeline
    end sub

    public function height()
        dim qq(), qh, qt, qc : redim qq(QSIZE-1) : qh = 0 : qt = 0 : qc = 0 ' queue variables
        if m_root is m_nil then
            height = 0
            exit function
        end if
        set qq(qh) = m_root : qh = (qh+1) mod QSIZE : qc = qc+1 ' enqueue root
        dim hcnt, lcnt : hcnt = 0 : lcnt = qc
        do until qc = 0 ' queue empty
            do until lcnt = 0
                dim node : set node = qq(qt) : qt = (qt+1) mod QSIZE : qc = qc-1     ' dequeue
                if not node.m_child(0) is m_nil then
                    set qq(qh) = node.m_child(0) : qh = (qh+1) mod QSIZE : qc = qc+1 ' enqueue left
                end if
                if not node.m_child(1) is m_nil then
                    set qq(qh) = node.m_child(1) : qh = (qh+1) mod QSIZE : qc = qc+1 ' enqueue right
                end if
                lcnt = lcnt-1
            loop
            hcnt = hcnt+1
            lcnt = qc ' set level count to next level size
        loop
        height = hcnt
    end function

end class

call main()
