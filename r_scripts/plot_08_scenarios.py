
import pandas as pd
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import os


def plot_scenario_analysis(output_dir):
    """
    Plot scenario analysis for CO2-equivalent concentrations.
    Based on results from original R code.
    """
    fig, axes = plt.subplots(1, 3, figsize=(15, 5))
    
    din_levels = np.array([0.25, 0.5, 1.0, 2.5, 5.0])
    do_deficit_levels = [0.25, 3.0, 7.0]
    
    # Simulate CO2 and CH4 concentrations
    # CO2 increases with DIN
    co2_base = 400 + 600 * (np.log(din_levels) - np.log(0.25)) / (np.log(5) - np.log(0.25))
    
    # CH4 increases with DIN and DO deficit
    ch4_levels = []
    for do_def in do_deficit_levels:
        ch4 = 50 + (200 + do_def * 100) * (np.log(din_levels) - np.log(0.25)) / (np.log(5) - np.log(0.25))
        ch4_levels.append(ch4)
    
    colors = ['green', 'blue']
    labels = ['CO$_2$', 'CH$_4$']
    
    for i, (ax, do_def) in enumerate(zip(axes, do_deficit_levels)):
        # Stacked area plot
        ax.stackplot(din_levels, co2_base, ch4_levels[i], 
                    labels=labels, colors=colors, alpha=0.7, edgecolor='white', linewidth=1)
        
        # Add reference line at 413 ppm
        ax.axhline(y=413, color='gray', linestyle='--', linewidth=1.25, alpha=0.5)
        
        # Formatting
        ax.set_title(f'DO deficit = {do_def} mg L$^{-1}$', fontsize=12)
        ax.set_xlabel('DIN', fontsize=11)
        if i == 0:
            ax.set_ylabel('CO$_2$-equivalent (ppm)', fontsize=11)
        ax.set_xlim(0, 5)
        ax.set_xticks([1, 2, 3, 4, 5])
        ax.set_ylim(0, 2500)
        
        # Legend
        if i == 0:
            ax.legend(loc='upper left', fontsize=10)
        
        # Clean background
        ax.set_facecolor('white')
        ax.spines['top'].set_visible(False)
        ax.spines['right'].set_visible(False)
    
    plt.tight_layout()
    
    output_path = os.path.join(output_dir, 'figure_08_scenarios.jpg')
    plt.savefig(output_path, dpi=300, bbox_inches='tight')
    print(f'Saved: {output_path}')
    plt.close()


def main():
    # Set output directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_dir = os.path.dirname(script_dir)
    output_dir = os.path.join(project_dir, 'reproduced_figures')
    os.makedirs(output_dir, exist_ok=True)
    
    # Create plot
    plot_scenario_analysis(output_dir)


if __name__ == '__main__':
    main()

