
import pandas as pd
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from scipy import stats
import os
import sys

# Add parent directory to path for importing data_utils
script_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, script_dir)
from data_utils import load_data, get_data_subsets


def plot_rel_ghg(dat, dat_m, output_dir):
    """
    Plot relationships between metabolism, DO deficit, and GHG fluxes.
    """
    fig, axes = plt.subplots(2, 2, figsize=(10, 11))
    axes = axes.flatten()
    
    # 1. GPP vs ER
    ax1 = axes[0]
    x1 = dat_m['GPP.mle']
    y1 = -dat_m['ER.mle']
    
    ax1.scatter(x1, y1, c='red', alpha=0.7, s=50, edgecolors='black', linewidth=0.5)
    
    # Linear regression
    slope1, intercept1, r_value1, _, _ = stats.linregress(x1, y1)
    x_line1 = np.linspace(x1.min(), x1.max(), 100)
    ax1.plot(x_line1, intercept1 + slope1 * x_line1, 'red', linewidth=2)
    ax1.plot(x_line1, x_line1, 'black', linewidth=1, linestyle='--')
    
    ax1.set_xlabel(r'GPP (mmol C m$^{-2}$ d$^{-1}$)', fontsize=11)
    ax1.set_ylabel(r'ER (mmol C m$^{-2}$ d$^{-1}$)', fontsize=11)
    ax1.text(0.95, 0.9, f'r = {r_value1:.2f}', transform=ax1.transAxes, 
            fontsize=13, fontweight='bold', ha='right')
    
    # 2. NEP vs DO deficit
    ax2 = axes[1]
    x2 = dat_m['NEP.mle']
    y2 = dat_m['do.def']
    
    ax2.scatter(x2, y2, c='red', alpha=0.7, s=50, edgecolors='black', linewidth=0.5)
    
    slope2, intercept2, r_value2, _, _ = stats.linregress(x2, y2)
    x_line2 = np.linspace(x2.min(), x2.max(), 100)
    ax2.plot(x_line2, intercept2 + slope2 * x_line2, 'red', linewidth=2)
    
    ax2.set_xlabel(r'NEP (mmol C m$^{-2}$ d$^{-1}$)', fontsize=11)
    ax2.set_ylabel(r'DO deficit (mg DO L$^{-1}$)', fontsize=11)
    ax2.text(0.95, 0.9, f'r = {r_value2:.2f}', transform=ax2.transAxes, 
            fontsize=13, fontweight='bold', ha='right')
    
    # 3. pCO2 vs FCO2
    ax3 = axes[2]
    x3 = dat['pCO2']
    y3 = dat['FCO2.h']
    
    # Color negative fluxes gold
    colors = ['blue' if f >= 0 else 'gold' for f in y3]
    ax3.scatter(x3, y3, c=colors, alpha=0.7, s=50, edgecolors='black', linewidth=0.5)
    
    slope3, intercept3, r_value3, _, _ = stats.linregress(x3, y3)
    x_line3 = np.linspace(x3.min(), x3.max(), 100)
    ax3.plot(x_line3, intercept3 + slope3 * x_line3, 'blue', linewidth=2)
    ax3.axhline(y=0, color='black', linewidth=1, linestyle='--')
    
    ax3.set_xlabel(r'pCO$_2$ ($\mu$ atm)', fontsize=11)
    ax3.set_ylabel(r'FCO$_2$ (mmol CO$_2$ m$^{-2}$ d$^{-1}$)', fontsize=11)
    ax3.text(0.95, 0.9, f'r = {r_value3:.2f}', transform=ax3.transAxes, 
            fontsize=13, fontweight='bold', ha='right')
    
    # 4. pCH4 vs FCH4
    ax4 = axes[3]
    x4 = dat['pCH4']
    y4 = dat['FCH4.h']
    
    ax4.scatter(x4, y4, c='green', alpha=0.7, s=50, edgecolors='black', linewidth=0.5)
    
    slope4, intercept4, r_value4, _, _ = stats.linregress(x4, y4)
    x_line4 = np.linspace(x4.min(), x4.max(), 100)
    ax4.plot(x_line4, intercept4 + slope4 * x_line4, 'green', linewidth=2)
    
    ax4.set_xlabel(r'pCH$_4$ ($\mu$ atm)', fontsize=11)
    ax4.set_ylabel(r'FCH$_4$ (mmol CO$_2$ m$^{-2}$ d$^{-1}$)', fontsize=11)
    ax4.text(0.95, 0.9, f'r = {r_value4:.2f}', transform=ax4.transAxes, 
            fontsize=13, fontweight='bold', ha='right')
    
    plt.tight_layout()
    
    # Save figure
    output_path = os.path.join(output_dir, 'figure_03_rel_ghg.jpg')
    plt.savefig(output_path, dpi=300, bbox_inches='tight')
    print(f'Saved: {output_path}')
    plt.close()


def main():
    # Load data
    dat = load_data()
    dat, dat_m = get_data_subsets(dat)
    
    # Set output directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_dir = os.path.dirname(script_dir)
    output_dir = os.path.join(project_dir, 'reproduced_figures')
    os.makedirs(output_dir, exist_ok=True)
    
    # Create plot
    plot_rel_ghg(dat, dat_m, output_dir)


if __name__ == '__main__':
    main()

