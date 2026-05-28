
import pandas as pd
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import os
import sys

# Set font
plt.rcParams.update({
    'font.family': 'Times New Roman',
    'mathtext.fontset': 'stix',
    'axes.unicode_minus': False
})

# Add parent directory to path for importing data_utils
script_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, script_dir)
from data_utils import load_data

def plot_hist_ghg(dat, output_dir):
    """
    Plot histograms of metabolism rates and GHG concentrations.
    """
    fig, axes = plt.subplots(2, 3, figsize=(9, 6))
    axes = axes.flatten()
    
    # Define variables, colors, and labels
    variables = [
        ('GPP.mle', 'red', r'GPP (mmol C m$^{-2}$ d$^{-1}$)'),
        ('ER.mle', 'red', r'ER (mmol C m$^{-2}$ d$^{-1}$)'),
        ('NEP.mle', 'red', r'NEP (mmol C m$^{-2}$ d$^{-1}$)'),
        ('algal production', 'orange', r'Algal production (Chl a m$^{-2}$ d$^{-1}$)'),
        ('pCO2', 'blue', r'pCO$_2$ ($\mu$ atm)'),
        ('pCH4', 'green', r'pCH$_4$ ($\mu$ atm)')
    ]
    
    for i, (var, color, xlabel) in enumerate(variables):
        ax = axes[i]
        if var == 'ER.mle':
            # ER is negative, take absolute value
            data = -dat[var].dropna()
        else:
            data = dat[var].dropna()
        
        # Plot histogram
        ax.hist(data, color=color, alpha=0.7, edgecolor='black')
        ax.set_xlabel(xlabel, fontsize=11)
        
        # Only show ylabel on first column
        if i % 3 == 0:
            ax.set_ylabel('Frequency', fontsize=11)
    
    plt.tight_layout()
    
    # Save figure
    output_path = os.path.join(output_dir, 'figure_02_hist_ghg.jpg')
    plt.savefig(output_path, dpi=300, bbox_inches='tight')
    print(f'Saved: {output_path}')
    plt.close()


def main():
    # Load data
    dat = load_data()
    
    # Set output directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_dir = os.path.dirname(script_dir)
    output_dir = os.path.join(project_dir, 'reproduced_figures')
    os.makedirs(output_dir, exist_ok=True)
    
    # Create plot
    plot_hist_ghg(dat, output_dir)


if __name__ == '__main__':
    main()

