import marimo

__generated_with = "0.13.15"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    import pandas as pd

    def __():
        # Try loading one of your CSV files
        try:
            df = pd.read_csv("results/smartbugs/data_analysis/all_patches_stats.csv")
            mo.md(f"✅ Successfully loaded data: {len(df)} rows")
            return df
        except FileNotFoundError:
            mo.md("❌ CSV file not found - make sure it's in the same directory")
            return None



    return mo, pd


@app.cell
def _(df, mo):
    def __():
        # Display data if loaded
        if df is not None:
            return mo.ui.table(df.head(10))
        else:
            return mo.md("No data to display")
    return


@app.cell
def _(pd):
    import os
    print(os.getcwd())
    df = pd.read_csv("results/smartbugs/data_analysis/all_patches_stats.csv")
    return (df,)


@app.cell
def _(df):
    df.keys()
    return


@app.cell
def _(df):
    search_tool='SolGPT'
    df[df['Tool'] ==search_tool]
    return


@app.cell
def _(df):
    search_contract='reentrance.sol'
    df[df['Original'] ==search_contract]
    return (search_contract,)


@app.cell
def _(df, search_contract):
    search_patch='reentrance.sol'
    df[df['Patch'] ==search_contract]
    return


if __name__ == "__main__":
    app.run()
