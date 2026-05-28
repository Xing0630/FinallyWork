
import os
import subprocess
import sys


def main():
    # Get script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    
    # List of all figure scripts in order
    figure_scripts = [
        'plot_01_rel_k600_ER.py',
        'plot_02_hist_ghg.py',
        'plot_03_rel_ghg.py',
        'plot_04_metabolism_coefficients.py',
        'plot_05_ghg_coefficients.py',
        'plot_06_variance_partitioning.py',
        'plot_07_sem_effects.py',
        'plot_08_scenarios.py'
    ]
    
    print('=' * 60)
    print('Starting to reproduce all figures from Gutierrez-Canovas et al. 2024')
    print('=' * 60)
    print()
    
    # Run each script
    for i, script_name in enumerate(figure_scripts, 1):
        script_path = os.path.join(script_dir, script_name)
        
        print(f'[{i}/{len(figure_scripts)}] Running: {script_name}')
        print('-' * 60)
        
        try:
            # Run the script
            result = subprocess.run(
                [sys.executable, script_path],
                capture_output=True,
                text=True,
                cwd=script_dir
            )
            
            # Print output
            if result.stdout:
                print(result.stdout.strip())
            if result.stderr:
                print('Warning:')
                print(result.stderr.strip())
                
        except Exception as e:
            print(f'Error running {script_name}: {e}')
        
        print()
    
    print('=' * 60)
    print('All figure scripts completed!')
    print('=' * 60)
    print()
    print('Reproduced figures can be found in:')
    project_dir = os.path.dirname(script_dir)
    output_dir = os.path.join(project_dir, 'reproduced_figures')
    print(f'  {output_dir}')


if __name__ == '__main__':
    main()

