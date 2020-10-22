(import nrc.fuzzy.*)

(import nrc.fuzz.jess.*)

(load-package nrc.fuzzy.jess.FuzzyFunctions)

;Defining the templates 
(deftemplate planner
	(slot distance (type INTEGER))
	(slot budget (type INTEGER))
	(slot preference (default 2))
	(slot time (type INTEGER))
	(slot beach (type INTEGER))
	(slot hike (type INTEGER))
    (slot history (type INTEGER))
)

(deftemplate budget_const
    "Auto-generated"
    (declare (ordered TRUE)))

(deftemplate time_const
    "Auto-generated"
    (declare (ordered TRUE)))

(deftemplate dist_const
    "Auto-generated"
    (declare (ordered TRUE)))


;Defining the global variables
(defglobal 
    ?*rest* = 0
    ?*valid* = 1
    ?*calc* = 0
    )

(defglobal ?*budget* = (new FuzzyVariable "Budget" 0.0 10000.0))
(defglobal ?*time* = (new FuzzyVariable "Time" 0.0 60))
(defglobal ?*dist* = (new FuzzyVariable "Distance" 0.0 10000.0))

; Rule 1
; Setting up Global variables
(defrule MAIN::init-FuzzyVariables
    (declare (salience 100))
    ?planner <- (planner)
    =>
    (?*budget* addTerm "low" (new ZFuzzySet 0 500))
    (?*budget* addTerm "mid" (new TrapezoidFuzzySet 501 1000 2000 5000))
    (?*budget* addTerm "high" (new SFuzzySet 5000 10000))

    (?*time* addTerm "low" (new ZFuzzySet 0 3))
    (?*time* addTerm "mid" (new TrapezoidFuzzySet 2 6 12 15))
    (?*time* addTerm "high" (new SFuzzySet 15 60))

    (?*dist* addTerm "low" (new ZFuzzySet 0 500))
    (?*dist* addTerm "mid" (new TrapezoidFuzzySet 500 1000 2000 5000))
    (?*dist* addTerm "high" (new SFuzzySet 5000 10000))

    (assert (budget_const (new FuzzyValue ?*budget* (new SingletonFuzzySet ?planner.budget))))
    (assert (time_const (new FuzzyValue ?*time* (new SingletonFuzzySet ?planner.time))))
    (assert (dist_const (new FuzzyValue ?*dist* (new SingletonFuzzySet ?planner.distance))))
    )

; Rule 2
; printing asserted data
(defrule initial
    (declare (salience 99))
    ?planner <- (planner)
    =>
    (printout t "********************Welcome to Travel Planner********************" crlf)
    (printout t "Your Travel Budget is being evaluated" crlf)
    (printout t "============" crlf)
    (printout t "Budget: " ?planner.budget crlf)
    (printout t "Time: " ?planner.time crlf)
    (printout t "Distance: " ?planner.distance crlf)
    (printout t "Preference: " ?planner.preference crlf)
    (printout t "Beach: " ?planner.beach crlf)
    (printout t "Hike: " ?planner.hike  crlf)
    (printout t "History: " ?planner.history crlf)
	)

; Rule 3
; validating budget
(defrule validateBudget
    (declare (salience 98))
    ?planner <- (planner)
    =>
    (if( and (or (= ?planner.preference 2) (= ?planner.preference 3)) (>= ?planner.distance 15000)) then
		(printout t "You cannot travel by Train or by Car for that long" crlf)
        (printout t "The longest continuous direct driving route in the world is 8,726 miles or 14,043 kilometers — from Sagres in Portugal to Khasan in Russia" crlf)    
    	(bind ?*valid* 0)
    elif(= ?planner.preference 1) then
    	(bind ?*calc* (- ?planner.budget (* (/ ?planner.distance 100 ) 5) (* ?planner.time 50)))
    	(if (<= ?*calc* 0) then
   		(printout t "Insufficient Budget" crlf)
        	(bind ?*valid* 0))
    elif(or (= ?planner.preference 2)(+ ?planner.preference 3)) then
    	(bind ?*calc* (- ?planner.budget (* ?planner.time 100)))
   		(if (<= ?*calc* 0) then
    		(printout t "Insufficient Budget" crlf)
        	(bind ?*valid* 0))
    )
)

; Rule 4
(defrule Location1
    (declare (salience 97))
    (budget_const ?planner&:(fuzzy-match ?planner "low"))(time_const ?planner2&:(fuzzy-match ?planner2 "low"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "low"))(planner{beach == 1})  
    =>
    (if (= ?*valid* 1) then
    	(printout t "You can visit Indiana Dunes" crlf) 
        (bind ?*rest* 1)
    )
)

; Rule 5
(defrule Location2
    (declare (salience 96))
    (budget_const ?planner&:(fuzzy-match ?planner "low"))(time_const ?planner2&:(fuzzy-match ?planner2 "mid"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "low"))(planner{beach == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can visit Cooper's Beach in New York" crlf)
    (bind ?*rest* 1))
)

; Rule 6
(defrule Location3
    (declare (salience 95))
    (budget_const ?planner&:(fuzzy-match ?planner "mid"))(time_const ?planner2&:(fuzzy-match ?planner2 "mid"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "mid"))(planner{beach == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can visit Miami, Florida" crlf)
    (bind ?*rest* 1))
)

; Rule 7
(defrule Location4
    (declare (salience 94))
    (budget_const ?planner&:(fuzzy-match ?planner "high"))(time_const ?planner2&:(fuzzy-match ?planner2 "mid"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "mid"))(planner{beach == 1})(planner{preference == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can visit Oahu, Hawaii" crlf)
    (bind ?*rest* 1))
)

; Rule 8
(defrule Location5
    (declare (salience 93))
    (budget_const ?planner&:(fuzzy-match ?planner "mid"))(time_const ?planner2&:(fuzzy-match ?planner2 "high"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "high"))(planner{beach == 1})(planner{preference == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can visit Phi Phi Islands in Thailand" crlf)
    (bind ?*rest* 1)) 
)

; Rule 9
(defrule Location6
    (declare (salience 92))
    (budget_const ?planner&:(fuzzy-match ?planner "high"))(time_const ?planner2&:(fuzzy-match ?planner2 "high"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "high"))(planner{beach == 1})(planner{preference == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can visit Australia" crlf)
    (bind ?*rest* 1))
)

; Rule 10
(defrule Location7
    (declare (salience 91))
    (budget_const ?planner&:(fuzzy-match ?planner "low"))(time_const ?planner2&:(fuzzy-match ?planner2 "low"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "low"))(planner{hike == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can visit Starved Rock State Park, Illinois" crlf)
    (bind ?*rest* 1)) 
)

; Rule 11
(defrule Location8
    (declare (salience 90))
    (budget_const ?planner&:(fuzzy-match ?planner "low"))(time_const ?planner2&:(fuzzy-match ?planner2 "mid"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "low"))(planner{hike == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can visit Mount Katahdin, Maine" crlf)
    (bind ?*rest* 1))
)

; Rule 12
(defrule Location9
    (declare (salience 89))
    (budget_const ?planner&:(fuzzy-match ?planner "mid"))(time_const ?planner2&:(fuzzy-match ?planner2 "mid"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "low"))(planner{hike == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can do the Tonto Trail, Arizona" crlf)
    (bind ?*rest* 1))
)

; Rule 13
(defrule Location10
    (declare (salience 88))
    (budget_const ?planner&:(fuzzy-match ?planner "mid"))(time_const ?planner2&:(fuzzy-match ?planner2 "mid"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "mid"))(planner{hike == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can do the Lost Coast Trail, California" crlf)
    (bind ?*rest* 1)) 
)

; Rule 14
(defrule Location11
    (declare (salience 87))
    (budget_const ?planner&:(fuzzy-match ?planner "mid"))(time_const ?planner2&:(fuzzy-match ?planner2 "mid"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "high"))(planner{hike == 1})(planner{preference == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can do the Inca Trail, Peru" crlf)
    (bind ?*rest* 1)) 
)

; Rule 15
(defrule Location12
    (declare (salience 86))
    (budget_const ?planner&:(fuzzy-match ?planner "mid"))(time_const ?planner2&:(fuzzy-match ?planner2 "high"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "high"))(planner{hike == 1})(planner{preference == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can do the Parvati Valley Trek, India" crlf)
    (bind ?*rest* 1))
)

; Rule 16
(defrule Location13
    (declare (salience 85))
    (budget_const ?planner&:(fuzzy-match ?planner "high"))(time_const ?planner2&:(fuzzy-match ?planner2 "high"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "high"))(planner{hike == 1})(planner{preference == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "There are a lot of interesting options, you can go to Switzerland or Nepal" crlf)
    (bind ?*rest* 1)) 
)

; Rule 17
(defrule Location14
    (declare (salience 84))
    (budget_const ?planner&:(fuzzy-match ?planner "low"))(time_const ?planner2&:(fuzzy-match ?planner2 "low"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "low"))(planner{history == 1}) 
 =>
    (if (= ?*valid* 1) then
    (printout t "You can visit Lincoln Home, Springfield" crlf)
    (bind ?*rest* 1))
)

; Rule 18
(defrule Location15
    (declare (salience 83))
    (budget_const ?planner&:(fuzzy-match ?planner "low"))(time_const ?planner2&:(fuzzy-match ?planner2 "low"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "mid"))(planner{history == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can visit Freedom Trail, Boston" crlf)
    (bind ?*rest* 1))
)

; Rule 19
(defrule Location16
    (declare (salience 82))
    (budget_const ?planner&:(fuzzy-match ?planner "mid"))(time_const ?planner2&:(fuzzy-match ?planner2 "mid"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "mid"))(planner{history == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can visit The Alamo, Texas" crlf)
    (bind ?*rest* 1))
)

; Rule 20
(defrule Location17
    (declare (salience 81))
    (budget_const ?planner&:(fuzzy-match ?planner "mid"))(time_const ?planner2&:(fuzzy-match ?planner2 "high"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "mid"))(planner{history == 1})(planner{preference == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can visit Egypt" crlf)
    (bind ?*rest* 1)) 
)

; Rule 21
(defrule Location18
    (declare (salience 80))
    (budget_const ?planner&:(fuzzy-match ?planner "mid"))(time_const ?planner2&:(fuzzy-match ?planner2 "high"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "high"))(planner{history == 1})(planner{preference == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can visit Rajasthan, India" crlf)
    (bind ?*rest* 1)) 
)

; Rule 22
(defrule Location19
    (declare (salience 79))
    (budget_const ?planner&:(fuzzy-match ?planner "mid"))(time_const ?planner2&:(fuzzy-match ?planner2 "mid"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "high"))(planner{history == 1})(planner{preference == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can visit Angkor Wat, Cambodia" crlf)
    (bind ?*rest* 1)) 
)

; Rule 23
(defrule Location20
    (declare (salience 78))
    (budget_const ?planner&:(fuzzy-match ?planner "high"))(time_const ?planner2&:(fuzzy-match ?planner2 "high"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "mid"))(planner{history == 1})(planner{preference == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can visit Roman Athens, Greece" crlf)
    (bind ?*rest* 1))
)

; Rule 24
(defrule Location21
    (declare (salience 77))
    (budget_const ?planner&:(fuzzy-match ?planner "high"))(time_const ?planner2&:(fuzzy-match ?planner2 "high"))
    (dist_const ?planner3&:(fuzzy-match ?planner3 "high"))(planner{history == 1})(planner{preference == 1})
 =>
    (if (= ?*valid* 1) then
    (printout t "You can visit Giza, Egypt" crlf)
    (bind ?*rest* 1)) 
)

; Rule 25
(defrule NotPresent
    (declare (salience 76))
    ?planner <- (planner)
 =>
    (if (and (= ?*rest* 0)(= ?*valid* 1) ) then
    (printout t "We do not have a plan for you" crlf)) 
)

; Rule 26
(defrule init
    (declare (salience 50))
	=>
(assert (planner (distance 800)(budget 400)(time 2)(hike 0)(beach 0)(history 1)(preference 1)))
)

(reset)
(facts)
(run) 