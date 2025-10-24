# snapshots

    Code
      enum(1:20)
    Output
      <Enum>
        1  : 1
        2  : 2
        3  : 3
        4  : 4
        5  : 5
        6  : 6
        7  : 7
        8  : 8
        9  : 9
        10 : 10
        11 : 11
        12 : 12
        13 : 13
        14 : 14
        15 : 15
        16 : 16
        17 : 17
        18 : 18
        19 : 19
        20 : 20

---

    Code
      enum(letters)
    Output
      <Enum>
        a : a
        b : b
        c : c
        d : d
        e : e
        f : f
        g : g
        h : h
        i : i
        j : j
      ... and 16 more

---

    Code
      print(enum(letters), n = NA)
    Output
      <Enum>
        a : a
        b : b
        c : c
        d : d
        e : e
        f : f
        g : g
        h : h
        i : i
        j : j
        k : k
        l : l
        m : m
        n : n
        o : o
        p : p
        q : q
        r : r
        s : s
        t : t
        u : u
        v : v
        w : w
        x : x
        y : y
        z : z

---

    Code
      print(enum(letters), n = 15)
    Output
      <Enum>
        a : a
        b : b
        c : c
        d : d
        e : e
        f : f
        g : g
        h : h
        i : i
        j : j
        k : k
        l : l
        m : m
        n : n
        o : o
      ... and 11 more

---

    Code
      Enum("Shapes", triangle = 3, square = 4, pentagon = 5, hexagon = 6)
    Output
      <Enum{Shapes}>
        triangle : 3
        square   : 4
        pentagon : 5
        hexagon  : 6

---

    Code
      format(enum(letters))
    Output
      [1] "<Enum :: a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z>"

---

    Code
      format(Enum("States", `names<-`(state.name, state.abb)))
    Output
      [1] "<Enum{States} :: AL:Alabama, AK:Alaska, AZ:Arizona, AR:Arkansas, CA:California, CO:Colorado, CT:Connecticut, DE:Delaware, FL:Florida, GA:Georgia, HI:Hawaii, ID:Idaho, IL:Illinois, IN:Indiana, IA:Iowa, KS:Kansas, KY:Kentucky, LA:Louisiana, ME:Maine, MD:Maryland, MA:Massachusetts, MI:Michigan, MN:Minnesota, MS:Mississippi, MO:Missouri, MT:Montana, NE:Nebraska, NV:Nevada, NH:New Hampshire, NJ:New Jersey, NM:New Mexico, NY:New York, NC:North Carolina, ND:North Dakota, OH:Ohio, OK:Oklahoma, OR:Oregon, PA:Pennsylvania, RI:Rhode Island, SC:South Carolina, SD:South Dakota, TN:Tennessee, TX:Texas, UT:Utah, VT:Vermont, VA:Virginia, WA:Washington, WV:West Virginia, WI:Wisconsin, WY:Wyoming>"

