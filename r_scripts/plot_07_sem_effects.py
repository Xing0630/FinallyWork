
import pandas as pd
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import os


def plot_sem_effects(output_dir):
    """
    Plot SEM standardized total effects for pCO2 and pCH4.
    Based on results from original R code.
    """
    fig, axes = plt.subplots(1, 2, figsize=(16, 8))
    
    predictors = ['discharge', 'rip_open', 'temp', 'din']
    
    # pCO2 effects
    co2_distal = [0.8, 0.4, 0.0, 0.2]
    co2_local = [0.2, 0.0, 0.0, 0.1]
    
    y_pos = np.arange(len(predictors))
    width = 0.35
    
    ax1 = axes[0]
    bars1_distal = ax1.barh(y_pos - width/2, co2_distal, width, 
                          color='gold', label='Distal')
    bars1_local = ax1.barh(y_pos + width/2, co2_local, width, 
                          color='lightblue', label='Local')
    
    ax1.set_yticks(y_pos)
    ax1.set_yticklabels(predictors, fontsize=12)
    ax1.set_xlabel('Absolute standardized total effects', fontsize=14)
    ax1.set_title('CO$_2$', fontweight='bold', fontsize=16)
    ax1.legend(fontsize=12)
    ax1.set_xlim(0, 1)
    
    # pCH4 effects
    ch4_distal = [0.7, 0.0, 0.5, 0.2]
    ch4_local = [0.1, 0.0, 0.2, 0.5]
    
    ax2 = axes[1]
    bars2_distal = ax2.barh(y_pos - width/2, ch4_distal, width, 
                          color='gold', label='Distal')
    bars2_local = ax2.barh(y_pos + width/2, ch4_local, width, 
                          color='lightblue', label='Local')
    
    ax2.set_yticks(y_pos)
    ax2.set_yticklabels(predictors, fontsize=12)
    ax2.set_xlabel('Absolute standardized total effects', fontsize=14)
    ax2.set_title('CH$_4$', fontweight='bold', fontsize=16)
    ax2.legend(fontsize=12)
    ax2.set_xlim(0, 1)
    
    plt.tight_layout()
    
    output_path = os.path.join(output_dir, 'figure_07_sem_effects.jpg')
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
    plot_sem_effects(output_dir)


if __name__ == '__main__':
    main()

