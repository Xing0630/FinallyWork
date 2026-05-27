
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
from data_utils import load_data


def plot_rel_k600_er(dat, output_dir):
    """
    Plot relationship between K600 and ER (absolute values).
    """
    fig, ax = plt.subplots(figsize=(5, 5.5))
    
    # Prepare data
    x = -dat['ER.mle']  # ER is negative in data
    y = dat['K600_hyd']
    
    # Scatter plot
    ax.scatter(x, y, c='red', alpha=0.7, s=50, edgecolors='black', linewidth=0.5)
    
    # Linear regression
    slope, intercept, r_value, p_value, std_err = stats.linregress(x, y)
    x_line = np.linspace(0, x.max(), 100)
    ax.plot(x_line, intercept + slope * x_line, 'red', linewidth=2)
    
    # Labels and formatting
    ax.set_xlabel(r'ER (mmol C m$^{-2}$ d$^{-1}$)', fontsize=12)
    ax.set_ylabel(r'K$_{600}$ (m d$^{-1}$)', fontsize=12)
    
    # Add correlation coefficient
    ax.text(0.75, 0.9, f'r = {r_value:.2f}', transform=ax.transAxes, 
            fontsize=13, fontweight='bold', ha='center')
    
    plt.tight_layout()
    
    # Save figure
    output_path = os.path.join(output_dir, 'figure_01_rel_k600_ER.jpg')
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
    plot_rel_k600_er(dat, output_dir)


if __name__ == '__main__':
    main()

