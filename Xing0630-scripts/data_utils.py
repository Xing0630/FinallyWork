
import pandas as pd
import numpy as np
import os


def load_data(data_dir=None):
    """
    Load and preprocess the stream metabolism and GHG data.
    """
    if data_dir is None:
        script_dir = os.path.dirname(os.path.abspath(__file__))
        project_dir = os.path.dirname(script_dir)
        data_dir = os.path.join(project_dir, 'data')
    
    data_path = os.path.join(data_dir, 'dat.txt')
    dat = pd.read_csv(data_path, sep='\t')
    
    # Calculate DO deficit
    dat = calculate_do_deficit(dat)
    
    # Calculate CH4:CO2 molar ratio
    dat = calculate_ghg_ratios(dat)
    
    # Calculate NEP (GPP + ER)
    dat['NEP.mle'] = dat['GPP.mle'] + dat['ER.mle']
    
    # Calculate riparian openness (from NDVI)
    dat['rip_open'] = car_logit(1 - dat['NDVI100m'])
    
    return dat


def calculate_do_deficit(dat):
    """
    Calculate dissolved oxygen deficit.
    Based on original R code using streamMetabolizer formulas.
    """
    # Calculate air pressure from elevation and air temperature
    air_temp = dat['air_mean_temp'].values
    alt = dat['alt'].values
    
    # Air pressure calculation (simplified)
    air_pres = 101.325 * np.exp(-alt / 8434.5)
    
    # Water temperature
    wt = dat['tmean'].values
    
    # Calculate DO saturation (simplified formula)
    # Based on Weiss 1970 formula
    do_sat = 14.652 - 0.41022 * wt + 0.0079910 * wt**2 - 0.000077774 * wt**3
    
    # Adjust for air pressure
    do_sat = do_sat * (air_pres / 101.325)
    
    # Calculate DO deficit
    dat['do.def'] = do_sat - dat['DOmean']
    
    return dat


def calculate_ghg_ratios(dat):
    """
    Calculate GHG ratios and CO2-equivalent.
    """
    # CH4:CO2 molar ratio
    pCH4_mmol = dat['pCH4'] / (12 + 1*4)  # CH4 molar mass
    pCO2_mmol = dat['pCO2'] / (12 + 16*2)  # CO2 molar mass
    dat['ch4co2_ratio'] = pCH4_mmol / pCO2_mmol
    
    # CO2-equivalent concentration (CH4 has 28x GWP)
    dat['pceq'] = 28 * dat['pCH4'] + dat['pCO2']
    dat['perCH4'] = 28 * dat['pCH4'] / dat['pceq']
    
    return dat


def car_logit(x):
    """
    Car logit transformation.
    """
    # Avoid 0 and 1
    x_safe = np.clip(x, 0.001, 0.999)
    return np.log(x_safe / (1 - x_safe))


def get_data_subsets(dat):
    """
    Get data subsets for metabolism analysis (removing sites with poor estimates).
    """
    # Remove sites 19, 28, 38, 41 (1-based index in R, convert to 0-based)
    bad_sites = [18, 27, 37, 40]
    dat_m = dat.drop(bad_sites).copy()
    
    return dat, dat_m

