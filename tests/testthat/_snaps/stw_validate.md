# check side-effects are correct for dictionary

    Code
      stw_check(meta_good, verbosity = "all")
    Message <message>
      v Dictionary names are unique.
    Message <message>
      v Dictionary names are all non-trivial.
    Message <message>
      v Dictionary descriptions are all non-trivial.
    Message <message>
      v Dictionary types are all recognized.
    Message <message>
      v Metadata has all required fields.
    Message <message>
      v Metadata sources valid.
    Message <message>
      v Metadata has all optional fields.

---

    Code
      stw_check(meta_good, verbosity = "info")

---

    Code
      stw_check(meta_good, verbosity = "error")

---

    Code
      stw_check(meta_good, verbosity = "none")

---

    Code
      stw_check(meta_missing_source, verbosity = "all")
    Message <message>
      v Dictionary names are unique.
    Message <message>
      v Dictionary names are all non-trivial.
    Message <message>
      v Dictionary descriptions are all non-trivial.
    Message <message>
      v Dictionary types are all recognized.
    Message <message>
      v Metadata has all required fields.
    Message <message>
      i Metadata missing optional fields: 'sources'.

---

    Code
      stw_check(meta_missing_source, verbosity = "info")
    Message <message>
      i Metadata missing optional fields: 'sources'.

---

    Code
      stw_check(meta_missing_source, verbosity = "error")

---

    Code
      stw_check(meta_missing_source, verbosity = "none")

---

    Code
      stw_check(meta_missing_name, verbosity = "all")
    Message <message>
      v Dictionary names are unique.
    Message <message>
      v Dictionary names are all non-trivial.
    Message <message>
      v Dictionary descriptions are all non-trivial.
    Message <message>
      v Dictionary types are all recognized.
    Message <message>
      x Metadata missing required fields: 'name'.
    Message <message>
      v Metadata sources valid.
    Message <message>
      v Metadata has all optional fields.

---

    Code
      stw_check(meta_missing_name, verbosity = "info")
    Message <message>
      x Metadata missing required fields: 'name'.

---

    Code
      stw_check(meta_missing_name, verbosity = "error")
    Message <message>
      x Metadata missing required fields: 'name'.

---

    Code
      stw_check(meta_missing_name, verbosity = "none")

# check side-effects are correct for meta

    Code
      stw_check(dict_good, verbosity = "all")
    Message <message>
      v Dictionary names are unique.
    Message <message>
      v Dictionary names are all non-trivial.
    Message <message>
      v Dictionary descriptions are all non-trivial.
    Message <message>
      v Dictionary types are all recognized.

---

    Code
      stw_check(dict_good, verbosity = "info")

---

    Code
      stw_check(dict_good, verbosity = "error")

---

    Code
      stw_check(dict_good, verbosity = "none")

---

    Code
      stw_check(dict_type_not_recognized, verbosity = "all")
    Message <message>
      v Dictionary names are unique.
    Message <message>
      v Dictionary names are all non-trivial.
    Message <message>
      v Dictionary descriptions are all non-trivial.
    Message <message>
      i Dictionary types not recognized for names: 'z'.

---

    Code
      stw_check(dict_type_not_recognized, verbosity = "info")
    Message <message>
      i Dictionary types not recognized for names: 'z'.

---

    Code
      stw_check(dict_type_not_recognized, verbosity = "error")

---

    Code
      stw_check(dict_type_not_recognized, verbosity = "none")

---

    Code
      stw_check(dict_names_repeated, verbosity = "all")
    Message <message>
      x Dictionary names are repeated: 'x'.
    Message <message>
      v Dictionary names are all non-trivial.
    Message <message>
      v Dictionary descriptions are all non-trivial.
    Message <message>
      v Dictionary types are all recognized.

---

    Code
      stw_check(dict_names_repeated, verbosity = "info")
    Message <message>
      x Dictionary names are repeated: 'x'.

---

    Code
      stw_check(dict_names_repeated, verbosity = "error")
    Message <message>
      x Dictionary names are repeated: 'x'.

---

    Code
      stw_check(dict_names_repeated, verbosity = "none")

