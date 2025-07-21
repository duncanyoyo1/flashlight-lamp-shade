# Parametric Flashlight Lamp Shade Generator (OpenSCAD)

This is a fully parametric, customizable flashlight lamp shade and diffuser system designed in OpenSCAD. It’s great for turning your favorite EDC lights (like the Emisar D4K or DA1K) into soft ambient lamps with a satisfying fit and finish.

No external libraries required. Everything is built from scratch.

---

## 🔧 Features

- 📏 **Supports common flashlight models** (D3AA, D4K, DA1K) or your own custom head diameter.
- 🔩 **Fully parametric design** — adjust width, height, angles, arm count, and more.
- 🌪️ **Auto-generated vertical fins** with intelligent spacing and conical correction.
- 🔄 **Customizable cutouts and arm connectors** for improved light diffusion.
- 🛠️ Works with OpenSCAD Customizer UI (Snap/Flatpak nightly versions included).

---

## 📸 Example Photos & Prints

<img alt="D3AA" src="https://github.com/user-attachments/assets/5d3564c7-62b3-40de-a5b1-a517af057b0a" />
<img alt="OpenSCAD Customizer" src="https://github.com/user-attachments/assets/dc74c5bf-18c6-4519-9068-669cd1a3006c" />

---

## 🧱 How to Use

### 🔢 1. Set Your Flashlight Model

```scad
model = "D3AA"; // ["D3AA", "DA1K", "D4K", "D4V2", "D4SV2", "KR1", "KR4", "K1", "K9.3", "KC1", "D1", "D1K", "D18", "DM1.12", "DM11", "M44", "TS10", "TS11", "TS25", "S21E", "Custom"]
```

If `Custom` is selected, set your own flashlight head diameter:

```scad
custom_head_diameter = 29.08; // In mm
```

### 🎛️ 2. Adjust Parameters

All parameters (ratios, cone angles, fin height/width, wall thickness, etc.) can be adjusted via:
- The variables at the top of the file, or
- The OpenSCAD Customizer panel

---

## 🖨️ Recommended Print Settings

- **Material:** PETG or PLA
- **Wall count:** 2–3
- **Infill:** 100%
- **Supports:** None needed
- **Orientation:** Print upright for best overhangs and finish

---

## 📦 Exporting to STL

After adjusting your model:
1. Press F6 (render)
2. File → Export → Export as STL

---

## 💡 Inspiration

This design was **inspired by other conical flashlight lamp shades** in the community but built entirely from scratch — all code and geometry are original. No external code or meshes were used or referenced directly.

---

## 🪪 License

This project is released under the **MIT License**.  
Use it, remix it, print it, even sell your prints. Just don’t blame me if your flashlight melts it. 🔥

---

## 🙏 Credits

- Thanks to the flashlight community on [r/flashlight](https://www.reddit.com/r/flashlight/) and [r/hanklights](https://www.reddit.com/r/hanklights/) for the obsession fuel.
- Built entirely with [OpenSCAD](https://openscad.org)

---
