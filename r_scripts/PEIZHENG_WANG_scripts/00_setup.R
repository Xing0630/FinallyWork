# =====================================================
# Setup
# =====================================================

required_packages <- c(
  "MuMIn",
  "usdm",
  "corrplot",
  "ade4",
  "viridis",
  "lattice",
  "lavaan",
  "piecewiseSEM",
  "relaimpo"
)

installed <- rownames(installed.packages())

for(pkg in required_packages){
  
  if(!(pkg %in% installed)){
    install.packages(pkg)
  }
}

invisible(lapply(required_packages,
                 library,
                 character.only = TRUE))

# Create outputs
 
dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/figures", showWarnings = FALSE)
dir.create("outputs/tables", showWarnings = FALSE)
cat("Setup completed.\n")
