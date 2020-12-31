# col_spec_diff printing works

    Code
      result_identical
    Message <cliMessage>
      
    Message <cliMessage>
      -- Column comparison -----------------------------------------------------------
    Message <cliMessage>
      v Column names and specifications are identical and have same order.

---

    Code
      result_missing_cols
    Message <cliMessage>
      
    Message <cliMessage>
      -- Column comparison -----------------------------------------------------------
    Message <cliMessage>
      ! Column names in y but not x:
    Output
         mpg  col_double() 
    Message <cliMessage>
      v Column names in both x and y have identical specifications.

---

    Code
      result_extra_cols
    Message <cliMessage>
      
    Message <cliMessage>
      -- Column comparison -----------------------------------------------------------
    Message <cliMessage>
      ! Column names in x but not y:
    Output
         cylo  col_double() 
    Message <cliMessage>
      v Column names in both x and y have identical specifications.

---

    Code
      result_missing_extra_cols
    Message <cliMessage>
      
    Message <cliMessage>
      -- Column comparison -----------------------------------------------------------
    Message <cliMessage>
      ! Column names in x but not y:
    Output
         cylo  col_double() 
    Message <cliMessage>
      ! Column names in y but not x:
    Output
          mpg  col_double() 
    Message <cliMessage>
      v Column names in both x and y have identical specifications.

---

    Code
      result_diff_order
    Message <cliMessage>
      
    Message <cliMessage>
      -- Column comparison -----------------------------------------------------------
    Message <cliMessage>
      i Column names are identical but have different order.
    Message <cliMessage>
      v Column names in both x and y have identical specifications.

---

    Code
      result_wrong_class
    Message <cliMessage>
      
    Message <cliMessage>
      -- Column comparison -----------------------------------------------------------
    Message <cliMessage>
      v Column names are identical and have same order.
    Message <cliMessage>
      ! Column specifications different in x:
    Output
         disp  col_character() 
    Message <cliMessage>
      ! Column specifications different in y:
    Output
         disp  col_double() 

---

    Code
      result_missing_extra_cols_wrong_class
    Message <cliMessage>
      
    Message <cliMessage>
      -- Column comparison -----------------------------------------------------------
    Message <cliMessage>
      ! Column names in x but not y:
    Output
         cylo  col_double() 
    Message <cliMessage>
      ! Column names in y but not x:
    Output
          mpg  col_double() 
    Message <cliMessage>
      ! Column specifications different in x:
    Output
         disp  col_character() 
    Message <cliMessage>
      ! Column specifications different in y:
    Output
         disp  col_double() 

---

    Code
      result_cars
    Message <cliMessage>
      
    Message <cliMessage>
      -- Column comparison -----------------------------------------------------------
    Message <cliMessage>
      ! Column names in x but not y:
    Output
           mpg  col_double() 
           cyl  col_double() 
          disp  col_double() 
            hp  col_double() 
          drat  col_double() 
            wt  col_double() 
          qsec  col_double() 
            vs  col_double() 
            am  col_double() 
          gear  col_double() 
          carb  col_double() 
    Message <cliMessage>
      ! Column names in y but not x:
    Output
         speed  col_double() 
          dist  col_double() 
    Message <cliMessage>
      ! There are no column names common to both x and y.

