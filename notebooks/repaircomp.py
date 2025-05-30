import marimo

__generated_with = "0.13.15"
app = marimo.App(width="medium")

@app.cell
def _(): 
    import marimo as mo
    import pandas as pd
    import polars as pl
    import os
    return pd,mo, pl, os


@app.cell
def _( mo, pl, pd):
    df = pl.read_csv(str(mo.notebook_location() / "public" / "all_patches_stats.csv"),infer_schema_length=10000)
    df.head()
    return (df,)


@app.cell
def _(df):
    search_tool='SolGPT'
    df.filter(pl.col('Tool') == search_tool)
    return


@app.cell
def _(df):
    search_contract='reentrance.sol'
    df.filter(pl.col('Original') == search_contract)
    return (search_contract,)


@app.cell
def _(df, search_contract):
    search_patch='reentrance.sol'
    df.filter(pl.col('Patch') == search_patch)
    return


if __name__ == "__main__":
    app.run()
